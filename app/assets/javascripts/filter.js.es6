class FilterTable {
  constructor(data, filters, tableElement, filterElement) {
    this.data = data;
    this.filters = filters;
    this.tableElement = tableElement;
    this.filterElement = filterElement;

    this.dimensions = {};
  }

  render() {
    this.table = this.tableElement.append('table')
      .attr('class', 'table table-striped table-responsive');

    let header = this.table.append('thead').append('tr');

    header.append('th').text('Name');
    header.append('th').text('JMS ID');
    header.append('th').text('Status');
    header.append('th').text('Location');
    header.append('th').text('Length of Stay');

    var bookings = crossfilter(this.data);
    var all = bookings.groupAll();
    this.dimensions.status = bookings.dimension(d => d.status);
    this.dimensions.location = bookings.dimension(d => d.facility_name);
    this.dimensions.gender = bookings.dimension(d => d.gender);
    this.dimensions.race = bookings.dimension(d => d.race);
    this.dimensions.lengthOfStay = bookings.dimension(this.lengthOfStay);

    this.filterLabels().forEach(filter => this.addBreakdownChart(filter));

    this.body = this.table.append('tbody')
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
      let className = segment.key.replace(/[ ']/g, '-');

      breakdownBars.append('div')
        .attr('class', `breakdown-bar ${className}`);

      breakdownTable.append('tr')
        .attr('class', `breakdown-row ${className}`)
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

  breakdown(dimensionName) {
    return this.dimensions[dimensionName]
      .group()
      .reduceCount()
      .top(Infinity);
  }

  update() {
    Object.keys(this.filters).forEach(dimensionName => {
      let values = Object
        .keys(this.filters[dimensionName])
        .map(d => this.filters[dimensionName][d]);

      if(values.indexOf(true) == -1)
        this.dimensions[dimensionName].filterAll();
      else
        this.dimensions[dimensionName].filterFunction(d => this.filters[dimensionName][d]);
    });

    let update = this.body
      .selectAll('tr')
      .data(this.dimensions.lengthOfStay.top(Infinity));

    update.exit().remove();

    let enter = update.enter()
      .append('tr');

    update.merge(enter).html(d => {
      let lengthOfStay = this.lengthOfStay(d);

      return [
        `<td>${d.first_name} ${d.last_name}</td>`,
        `<td>${d.jms_person_id}</td>`,
        `<td>${d.status}</td>`,
        `<td>${d.facility_name}</td>`,
        `<td>${this.distanceOfTimeInWords(lengthOfStay)}</td>`,
      ].join('');
    });

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

        let className = segment.key.replace(/[ ']/g, '-');

        breakdownBars.selectAll(`.breakdown-bar.${className}`)
          .style('flex', `0 1 ${this.percentage(segment.value, totalCount)}`);

        let row = breakdownTable.select(`.breakdown-row.${className}`);

        row.classed('active', this.filters[dimensionName][segment.key]);

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
