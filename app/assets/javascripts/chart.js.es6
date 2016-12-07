class PopulationCapacityChart {
  constructor(args) {
    this.args = args;

    this.labels = {
      capacity: 'capacity',
      soft_cap: 'soft cap',
      red_zone_start: 'red zone start',
      hard_cap: 'hard cap',
    }
  }

  reverseLookup(objOriginal, comparedValue) {
    const values = Object.keys(objOriginal).map(function (key) {
      return objOriginal[key];
    });

    const index = values.indexOf(comparedValue);

    return Object.keys(objOriginal)[index];
  }

  graphMaximumX() {
    return Math.max(this.args.active_bookings, this.args.markers.hard_cap);
  }

  numberOverThreshold() {
    const passedMarkers = objectValues(this.args.markers).filter((markerAmount) => {
      return markerAmount < this.args.active_bookings;
    });

    if(passedMarkers.length === 0) {
      return null;
    }

    const largestPassedThreshold = Math.max(...passedMarkers);

    return {
      amountOver: this.args.active_bookings - largestPassedThreshold,
      threshold: this.reverseLookup(this.args.markers, largestPassedThreshold)
    };
  }

  render(targetElement) {
    const markerValues = objectValues(this.args.markers);

    const margin = { top: 20, right: 20, bottom: 60, left: 40 };
    const width = 800 - margin.left - margin.right;
    const height = 200 - margin.top - margin.bottom;

    const svg = targetElement
      .append('svg')
        .attr('height', height + margin.top + margin.bottom)
        .attr('width', width + margin.left + margin.right)
      .append('g')
        .attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')');

    const xScale = d3.scaleLinear()
            .domain([0, this.graphMaximumX()])
            .range([0, width]);

    svg.append('rect')
      .attr('class', 'active-bookings')
      .attr('width', xScale(this.args.active_bookings))
      .attr('y', height / 2)
      .attr('height', height / 2);

    svg.append('rect')
      .attr('class', 'red-zone')
      .attr('width', xScale(this.args.markers.hard_cap - this.args.markers.red_zone_start))
      .attr('x', xScale(this.args.markers.red_zone_start))
      .attr('height', height);

    const markerAxis = d3.axisTop(xScale)
      .tickSize(height)
      .tickValues(markerValues);

    const xAxis = d3.axisBottom(xScale);

    svg.append('g')
      .attr('transform', 'translate(0, ' + height + ')')
      .attr('class', 'marker-axis')
      .call(markerAxis);

    svg.append('g')
      .attr('transform', 'translate(0, ' + height + ')')
        .call(xAxis);

    targetElement.selectAll('.marker-axis .tick line')
      .attr('class', (node) => this.reverseLookup(this.args.markers, node));

    let overThreshold = this.numberOverThreshold();

    let statsElement = targetElement
      .append('div')
        .attr('class', 'pop-capacity-stats');

    statsElement
      .append('div')
        .attr('class', 'bed-count')
        .text(`${this.args.active_bookings} people in beds`);

    if (overThreshold) {
      statsElement.append('div')
          .attr('class', 'over-threshold-count')
          .text(`${overThreshold.amountOver} over ${this.labels[overThreshold.threshold]}`);
    }
  }
};