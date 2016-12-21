class HistoricalChart {
  constructor(data, chartElement) {
    this.data = data;
    this.chartElement = chartElement;
    this.dimensions = {};
    this.filters = {};
  }

  filtersUpdated(data) {
    this.data = data;
    console.log("filters updated: ");
    console.log(this.data);
    // this.update();
  }

  render() {
    console.log("in render: ");
    console.log(this.data);

    // this should reflect total # of active bookings for currentDate
    console.log(bookings.groupAll().reduceCount().value());

  }
}
