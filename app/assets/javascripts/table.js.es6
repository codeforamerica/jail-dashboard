class Table {
  constructor(tableElement) {
    this.tableElement = tableElement;
  }

  render() {
    this.table = this.tableElement.append('table')
      .attr('class', 'table table-striped table-responsive');

    const header = this.table.append('thead').append('tr');
    header.append('th').text('Name');
    header.append('th').text('JMS ID');
    header.append('th').text('Status');
    header.append('th').text('Location');
    header.append('th').text('Length of Stay');

    this.body = this.table.append('tbody');
  }

  update(bookings) {
    let update = this.body
      .selectAll('tr')
      .data(bookings);

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
}
