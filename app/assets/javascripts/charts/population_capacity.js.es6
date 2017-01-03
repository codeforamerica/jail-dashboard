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
    const targetWidth = parseInt(targetElement.style('width'));

    const renderedHeight = 200;
    const renderedWidth = targetWidth;

    const markerValues = objectValues(this.args.markers);
    const markerLabels = objectValues(this.labels);

    const margin = { top: 20, right: 20, bottom: 60, left: 20 };

    const width = renderedWidth - margin.left - margin.right;
    const height = renderedHeight - margin.top - margin.bottom;

    const svg = targetElement.append('svg')
      .attr('preserveAspectRatio', 'none')
      .attr('height', renderedHeight)
      .attr('width', renderedWidth);

    this.appendPatterns(svg);

    const chart = svg.append('g')
      .attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')');

    const xScale = d3.scaleLinear()
            .domain([0, this.graphMaximumX()])
            .range([0, width]);

    this.drawBar(chart, xScale, height);

    chart.append('rect')
      .attr('class', 'red-zone')
      .attr('width', xScale(this.args.markers.hard_cap - this.args.markers.red_zone_start))
      .attr('x', xScale(this.args.markers.red_zone_start))
      .attr('height', height);

    const markerAxis = d3.axisTop(xScale)
      .tickSize(height)
      .tickFormat(d => { const i = markerValues.indexOf(d); return markerLabels[i]; })
      .tickValues(markerValues);

    const xAxis = d3.axisBottom(xScale);

    chart.append('g')
      .attr('transform', 'translate(0, ' + height + ')')
      .attr('class', 'marker-axis')
      .call(markerAxis);

    chart.append('g')
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

  appendPatterns(svg) {
    const iconSize = 48;
    const iconPadding = 12;
    const patternHeight = 85;

    const patternDefs = svg.append('defs');

    patternDefs
      .append('pattern')
        .attr('id', 'bed')
        .attr('patternUnits', 'userSpaceOnUse')
        .attr('width', iconSize + iconPadding)
        .attr('height', patternHeight)
      .append('image')
        .attr('xlink:href', '/assets/bed.svg')
        .attr('width', iconSize)
        .attr('height', iconSize);

    patternDefs
      .append('pattern')
        .attr('id', 'boat')
        .attr('patternUnits', 'userSpaceOnUse')
        .attr('width', iconSize + iconPadding)
        .attr('height', patternHeight)
      .append('image')
        .attr('xlink:href', '/assets/boat.svg')
        .attr('width', iconSize)
        .attr('height', iconSize);
  }

  drawBar(chart, xScale, height) {
    const boatsInUse =
      this.args.active_bookings > this.args.markers.red_zone_start;

    const bedsBarUpperLimit =
      Math.min(this.args.markers.red_zone_start, this.args.active_bookings);

    chart.append('rect')
      .attr('class', 'active-bookings active-booking-beds')
      .attr('width', xScale(bedsBarUpperLimit))
      .attr('y', height / 2)
      .attr('fill', 'url(#bed)')
      .attr('height', height / 2);

    if(boatsInUse) {
      chart.append('rect')
        .attr('class', 'active-bookings active-booking-boats')
        .attr('width', xScale(this.args.active_bookings - bedsBarUpperLimit))
        .attr('y', height / 2)
        .attr('x', xScale(bedsBarUpperLimit))
        .attr('fill', 'url(#boat)')
        .attr('height', height / 2);
    }
  }

  redraw(targetElement) {
    targetElement.selectAll('*').remove();
    this.render(targetElement);
  }
};
