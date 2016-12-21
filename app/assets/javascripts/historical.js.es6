class HistoricalChart {
  constructor(data, chartElement) {
    this.data = data;
    this.chartElement = chartElement;
    this.dimensions = {};
    this.filters = {};
  }

  filtersUpdated(data) {
    this.data = data;

    console.log(this.data);
    debugger;
    // this.update();
  }

  render() {
    console.log("in render: ");
    console.log(this.data);
    debugger;

    // dummy date for logging
    var currentDate = new Date(2016,3,18);
    byBooked.filterFunction(d => d < currentDate);
    byReleased.filterFunction(d => d == null || d > currentDate);

    // this should reflect total # of active bookings for currentDate
    console.log(bookings.groupAll().reduceCount().value());

  }
}
