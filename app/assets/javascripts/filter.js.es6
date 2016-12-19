class FilterTable {
  constructor(data, filters, tableElement, filterElement) {
    this.data = data;
    this.filters = filters;
    this.tableElement = tableElement;
    this.filterElement = filterElement;

    this.dimensions = {};
  }

  render() {
    this.addFilterButtons('status');
    this.addFilterButtons('location');
    this.addFilterButtons('gender');
    this.addFilterButtons('race');

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
    this.dimensions.length_of_stay = bookings.dimension(this.length_of_stay);

    this.body = this.table.append('tbody')
    this.update();
  }

  addFilterButtons(dimensionName) {
    let filterGroup = this
      .filterElement
      .append('div')
      .attr('class', `filter-${dimensionName}`);

    filterGroup.append('h3')
      .text(`Filter by ${dimensionName}`)

    this.filters[dimensionName].forEach((filterName) => {
        filterGroup
        .append('button')
        .text(filterName)
        .on('click', () => {
            this.dimensions[dimensionName].filter(filterName);
            this.update();
            })
        })

    filterGroup
      .append('button')
      .text('all')
      .on('click', () => {
        this.dimensions[dimensionName].filterAll();
        this.update();
      })
  }

  update() {
    let update = this.body
      .selectAll('tr')
      .data(this.dimensions.length_of_stay.top(Infinity));

    update.exit().remove();

    let enter = update.enter()
      .append('tr');

    update.merge(enter).html(d => {
      let length_of_stay = this.length_of_stay(d);

      return [
        `<td>${d.first_name} ${d.last_name}</td>`,
        `<td>${d.jms_person_id}</td>`,
        `<td>${d.status}</td>`,
        `<td>${d.facility_name}</td>`,
        `<td>${this.distance_of_time_in_words(length_of_stay)}</td>`,
      ].join('')
    });
  }

  length_of_stay(booking) {
    if(booking.release_date_time)
      return new Date(booking.booking_date_time) - new Date(booking.release_date_time)
    else
      return new Date() - new Date(booking.booking_date_time)
  }

  distance_of_time_in_words(duration) {
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
    if (distance_in_minutes < 1051199) { return 'about a year'; }

    return 'over ' + Math.floor(distance_in_minutes / 525960) + ' years';
  }
}
