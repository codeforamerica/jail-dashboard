class Filter {
  constructor(data, filters, filterElement, tableCallback) {
    this.data = this.processDates(data);
    this.filters = filters;
    this.filterElement = filterElement;
    this.tableCallback = tableCallback;

    this.dimensions = {};
    this.onUpdateCallbacks = [];
    this.activeDateTime = new Date();
  }

  processDates(data) {
    // pre-formatting for dates
    data.forEach(function(p) {   
      p.booking_date_time = new Date(p.booking_date_time);

      // keep nulls null; else a new Date on null will set in 1969
      if (p.release_date_time == null) {
        p.release_date_time = null;
      }
      else {
        p.release_date_time = new Date(p.release_date_time);
      }
    });

    return data;
  }

  render() {
    var bookings = crossfilter(this.data);
    var all = bookings.groupAll();

    this.dimensions.status = bookings.dimension(d => d.status);
    this.dimensions.location = bookings.dimension(d => d.facility_name);
    this.dimensions.gender = bookings.dimension(d => d.gender);
    this.dimensions.race = bookings.dimension(d => d.race);
    this.dimensions.lengthOfStay = bookings.dimension(this.lengthOfStay);
    this.dimensions.category = bookings.dimension(d => d.category);
    this.dimensions.description = bookings.dimension(d => d.description);
    this.dimensions.bookingDateTime = bookings.dimension(d => d.booking_date_time);
    this.dimensions.releaseDateTime = bookings.dimension(d => d.release_date_time);

    this.filterLabels().forEach(filter => this.addBreakdownChart(filter));

    this.update();
  }

  filterLabels() {
    return Object.keys(this.filters);
  }

  addBreakdownChart(dimensionName) {
    let breakdownElement = this
      .filterElement
      .append('div')
      .attr('class', `breakdown-${dimensionName}`);

    breakdownElement.append('h3')
      .text(`Filter by ${dimensionName}`);

    let breakdownBars = breakdownElement.append('div')
      .attr('class', `breakdown-bars ${dimensionName}`);

    let breakdownTable = breakdownElement.append('table')
      .attr('class', `table table-striped table-responsive breakdown-table ${dimensionName}`);

    this.breakdown(dimensionName).forEach(segment => {
      let className = this.classify(segment.key);

      breakdownBars.append('div')
        .attr('class', `breakdown-bar ${className}`);

      breakdownTable.append('tr')
        .attr('class', `breakdown-row ${className}`)
        .attr('role', 'link')
        .on('click', () => {
          this.filters[dimensionName][segment.key] = !this.filters[dimensionName][segment.key];
          this.update();
        });
    });

    breakdownElement
      .append('button')
      .text(`Clear ${dimensionName} filters`)
      .on('click', () => {
        Object.keys(this.filters[dimensionName]).forEach(filterName => {
          this.filters[dimensionName][filterName] = false;
        });

        this.update();
      });
  }

  classify(string) {
    // make sure it's a string
    string = '' + string;

    return string.replace(/[ '\/]/g, '-');
  }

  breakdown(dimensionName) {
    return this.dimensions[dimensionName]
      .group()
      .reduceCount()
      .top(Infinity);
  }

  onUpdate(callback) {
    this.onUpdateCallbacks = this.onUpdateCallbacks.concat(callback);
  }

  update() {
    // update the crossfilter
    Object.keys(this.filters).forEach(dimensionName => {
      if(this.filtersAllInactive(dimensionName))
        this.dimensions[dimensionName].filterAll();
      else
        this.dimensions[dimensionName].filterFunction(d => this.filters[dimensionName][d]);
    });

    // clear time-bound filters
    this.dimensions.bookingDateTime.filterAll();
    this.dimensions.releaseDateTime.filterAll();

    // call update callbacks with historical data
    let selectedBookings = this.dimensions.lengthOfStay.top(Infinity);
    this.onUpdateCallbacks.forEach(callback => callback(selectedBookings));

    // collapse all the data down into the currently active ones
    let currentDate = this.activeDateTime;
    this.dimensions.bookingDateTime.filterFunction(d => d < currentDate);
    this.dimensions.releaseDateTime.filterFunction(d => d == null || d > currentDate);

    // call update callbacks with current bookings
    let selectedBookingsAtSinglePointInTime = this.dimensions.lengthOfStay.top(Infinity);
    this.tableCallback(selectedBookingsAtSinglePointInTime);

    this.filterLabels().forEach(dimensionName => {
      let totalCount = this.dimensions[dimensionName]
        .groupAll()
        .reduceCount()
        .value();

      this.breakdown(dimensionName).forEach(segment => {
        let breakdownBars = this.filterElement
          .select(`.breakdown-bars.${dimensionName}`);

        let breakdownTable = this.filterElement
          .select(`.breakdown-table.${dimensionName}`);

        let className = this.classify(segment.key);

        breakdownBars.selectAll(`.breakdown-bar.${className}`)
          .style('flex', `0 1 ${this.percentage(segment.value, totalCount)}`)
          .classed(
              'active',
              this.filtersAllInactive(dimensionName) ||
              this.filters[dimensionName][segment.key]
              );

        let row = breakdownTable.select(`.breakdown-row.${className}`);

        row
          .classed(
              'active',
              this.filtersAllInactive(dimensionName) ||
              this.filters[dimensionName][segment.key]
              );

        row.selectAll('th, td').remove();
        row.append('th')
          .text(segment.key);
        row.append('td')
          .attr('class', 'breakdown-value')
          .text(segment.value);
        row.append('td')
          .attr('class', 'breakdown-percentage')
          .text(this.percentage(segment.value, totalCount));
      });
    });
  }

  filtersAllInactive(dimensionName) {
    return Object
      .keys(this.filters[dimensionName])
      .map(d => this.filters[dimensionName][d])
      .indexOf(true) == -1;
  }

  lengthOfStay(booking) {
    if(booking.release_date_time)
      return new Date(booking.release_date_time) - new Date(booking.booking_date_time);
    else
      return new Date() - new Date(booking.booking_date_time);
  }

  distanceOfTimeInWords(duration) {
    var distance_in_seconds = (duration / 1000);
    var distance_in_minutes = Math.floor(distance_in_seconds / 60);
    distance_in_minutes = Math.abs(distance_in_minutes);
    if (distance_in_minutes == 0) { return 'less than a minute'; }
    if (distance_in_minutes == 1) { return 'a minute'; }
    if (distance_in_minutes < 45) { return distance_in_minutes + ' minutes'; }
    if (distance_in_minutes < 90) { return 'about an hour'; }
    if (distance_in_minutes < 1440) { return 'about ' + Math.floor(distance_in_minutes / 60) + ' hours'; }
    if (distance_in_minutes < 2880) { return 'a day'; }
    if (distance_in_minutes < 43200) { return Math.floor(distance_in_minutes / 1440) + ' days'; }
    if (distance_in_minutes < 86400) { return 'about a month'; }
    if (distance_in_minutes < 525960) { return Math.floor(distance_in_minutes / 43200) + ' months'; }
    if (distance_in_minutes < 1051199) { return 'about 1 year'; }

    return 'over ' + Math.floor(distance_in_minutes / 525960) + ' years';
  }

  percentage(partial, total) {
    let percentageScale = d3.scaleLinear()
      .domain([0, total])
      .range([0, 100]);

    let format = d3.format('d');

    return format(percentageScale(partial)) + '%';
  }
}
