describe('Population Capacity bar chart', function() {
  var chartElement;
  var args;

  beforeEach(function() {
      args = {
        active_bookings: 25,
        markers : {
          capacity: 40,
          soft_cap: 50,
          red_zone_start: 55,
          hard_cap: 60
        }
      };
  });

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
      window.PopulationCapacityChart(args).render(chartElement);

      var widthOfChart = 740;
      var expectedWidth = args.active_bookings / args.markers.hard_cap * widthOfChart;

      var bar = chartElement.select('.active-bookings');
      var barChartWidth = parseFloat(bar.attr('width'), 10);

      expect(barChartWidth).toEqual(expectedWidth);
    });

  });

  describe('graphMaximumX', function() {
    it('returns active bookings when more active bookings than hard cap', function() {
      args.active_bookings = args.markers.hard_cap + 10;

      var graphMaximum = window.PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.active_bookings);
    });

    it('returns hard cap when less active bookings than hard cap', function() {
      args.markers.hard_cap = args.active_bookings + 10;

      var graphMaximum = window.PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.markers.hard_cap);
    });
  });

  describe('numberOverThreshold', function() {
    it('return null if not over capacity', function() {
      args.active_bookings = args.markers.capacity - 5;

      var overThreshold = window.PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toBeNull();
    });

    it('returns number over capacity', function() {
      args.active_bookings = args.markers.capacity + 5;

      var overThreshold = window.PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'capacity' });
    });

    it('returns number over soft cap', function() {
      args.active_bookings = args.markers.soft_cap + 5;

      var overThreshold = window.PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'soft_cap' });
    });

    it('returns number over hard cap', function() {
      args.active_bookings = args.markers.hard_cap + 5;

      var overThreshold = window.PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'hard_cap' });
    });
  });
});
