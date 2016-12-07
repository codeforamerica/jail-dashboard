describe('Population Capacity bar chart', () => {
  let chartElement;
  let args;

  beforeEach(() => {
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

  describe('render()', () => {
    beforeEach(() => {
      chartElement = d3.select('body')
        .append('div')
          .attr('class', 'chartElement');
    });

    afterEach(() => {
      chartElement.remove();
    });

    it('scales bar width to number of active bookings', () => {
      new PopulationCapacityChart(args).render(chartElement);

      const widthOfChart = 740;
      const expectedWidth = args.active_bookings / args.markers.hard_cap * widthOfChart;

      const bar = chartElement.select('.active-bookings');
      const barChartWidth = parseFloat(bar.attr('width'), 10);

      expect(barChartWidth).toEqual(expectedWidth);
    });

  });

  describe('graphMaximumX', () => {
    it('returns active bookings when more active bookings than hard cap', () => {
      args.active_bookings = args.markers.hard_cap + 10;

      const graphMaximum = new PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.active_bookings);
    });

    it('returns hard cap when less active bookings than hard cap', () => {
      args.markers.hard_cap = args.active_bookings + 10;

      const graphMaximum = new PopulationCapacityChart(args).graphMaximumX();
      expect(graphMaximum).toEqual(args.markers.hard_cap);
    });
  });

  describe('numberOverThreshold', () => {
    it('return null if not over capacity', () => {
      args.active_bookings = args.markers.capacity - 5;

      const overThreshold = new PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toBeNull();
    });

    it('returns number over capacity', () => {
      args.active_bookings = args.markers.capacity + 5;

      const overThreshold = new PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'capacity' });
    });

    it('returns number over soft cap', () => {
      args.active_bookings = args.markers.soft_cap + 5;

      const overThreshold = new PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'soft_cap' });
    });

    it('returns number over hard cap', () => {
      args.active_bookings = args.markers.hard_cap + 5;

      const overThreshold = new PopulationCapacityChart(args).numberOverThreshold();

      expect(overThreshold).toEqual({ amountOver: 5, threshold: 'hard_cap' });
    });
  });
});
