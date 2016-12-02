describe('Population Capacity bar chart', function() {
  var chart;
  var maxPopulation = 40;
  var activeBookings = 25.0;

  beforeEach(function() {
    chart = d3.select('body')
      .append('div')
        .attr('class', 'chart')
        .attr('data-soft-cap', 10)
        .attr('data-red-zone-start', 20)
        .attr('data-hard-cap', 30)
        .attr('data-max-population', maxPopulation)
        .attr('data-active-bookings', activeBookings);

    window.renderPopulationCapacityChart(chart);
  });

  afterEach(function() {
    chart.remove();
  });

  it('scales bar width to number of active bookings', function() {
    var widthOfChart = 740;

    var bar = chart.select('.active-bookings');

    var barChartWidth = parseFloat(bar.attr('width'), 10);
    expect(barChartWidth).toEqual(activeBookings/maxPopulation * widthOfChart);
  });

});
