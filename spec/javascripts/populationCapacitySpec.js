describe('Population Capacity bar chart', function() {
  var chartElement;
  var defaultArgs = {
    markers: {
      capacity: 40,
      hard_cap: 60
    },
    active_bookings: 25.0
  };

  describe('render()', function() {
    beforeEach(function() {
      chartElement = d3.select('body')
        .append('div')
          .attr('class', 'chartElement');
    });

    afterEach(function() {
      chartElement.remove();
    });

    it('scales bar width to number of active bookings', function() {
      window.PopulationCapacityChart(defaultArgs).render(chartElement);

      var widthOfChart = 740;
      var expectedWidth = defaultArgs.active_bookings / defaultArgs.markers.hard_cap * widthOfChart;

      var bar = chartElement.select('.active-bookings');
      var barChartWidth = parseFloat(bar.attr('width'), 10);

      expect(barChartWidth).toEqual(expectedWidth);
    });

  });

  describe('graphMaximumX', function() {
    it('returns active bookings when more active bookings than hard cap', function() {
      var args = defaultArgs;
      args.active_bookings = args.hard_cap + 10;

      var graphMaximum = window.PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.active_bookings);
    });

    it('returns hard cap when less active bookings than hard cap', function() {
      var args = defaultArgs;
      args.hard_cap = args.active_bookings + 10;

      var graphMaximum = window.PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.hard_cap);
    });
  });

});
