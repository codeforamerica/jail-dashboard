class HistoricalChart {
  constructor(data, chartElement) {
    this.data = data;
    this.chartElement = chartElement;
    this.dimensions = {};
  }

  render() {
    

    // pre-formatting for dates
    this.data.forEach(function(p) {   
      p.booking_date_time = new Date(p.booking_date_time);

      // keep nulls null; else a new Date on null will set in 1969
      if (p.release_date_time == null) {
        p.release_date_time = null
      }
      else {
        p.release_date_time = new Date(p.release_date_time);
      }
    });

    var bookings = crossfilter(this.data);

    // define date-based filters
    var byBooked = bookings.dimension(function(p) { return p.booking_date_time; });
    var byReleased = bookings.dimension(function(p) { return p.release_date_time; });

    // dummy date for logging
    var currentDate = new Date(2016,3,18);
    byBooked.filterFunction(d => d < currentDate);
    byReleased.filterFunction(d => d == null || d > currentDate);

    // this should reflect total # of active bookings for currentDate
    console.log(bookings.groupAll().reduceCount().value());

  }
}
