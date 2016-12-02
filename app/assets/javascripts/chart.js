window.renderPopulationCapacityChart = function(chart) {
  var parseIntAttr = function(element, attrName) {
    return parseInt(element.attr(attrName), 10);
  };

  var markers = {
    'softCap': parseIntAttr(chart, 'data-soft-cap'),
    'redZoneStart': parseIntAttr(chart, 'data-red-zone-start'),
    'hardCap':parseIntAttr(chart, 'data-hard-cap'),
    'maxPopulation': parseIntAttr(chart, 'data-max-population'),
  };

  var markerValues = [];

  for (var key in markers) {
    markerValues = markerValues.concat(markers[key]);
  }

  var activeBookings = parseIntAttr(chart, 'data-active-bookings');

  var margin = { top: 20, right: 20, bottom: 60, left: 40 };
  var width = 800 - margin.left - margin.right;
  var height = 200 - margin.top - margin.bottom;

  var svg = chart
    .append('svg')
      .attr('height', height + margin.top + margin.bottom)
      .attr('width', width + margin.left + margin.right)
    .append('g')
      .attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')');

  var xScale = d3.scaleLinear()
          .domain([0, markers.maxPopulation])
          .range([0, width]);

  svg.append('rect')
    .attr('class', 'active-bookings')
    .attr('width', xScale(activeBookings))
    .attr('y', height / 2)
    .attr('height', height / 2);

  svg.append('rect')
    .attr('class', 'red-zone')
    .attr('width', xScale(markers.hardCap - markers.redZoneStart))
    .attr('x', xScale(markers.redZoneStart))
    .attr('height', height);

  svg.append('text')
    .text(activeBookings)
    .attr('x', xScale(activeBookings) / 2)
    .attr('y', height/2)
    .attr('text-anchor', 'middle');

  var markerAxis = d3.axisTop(xScale)
    .tickSize(height)
    .tickValues(markerValues);

  var xAxis = d3.axisBottom(xScale);

  svg.append('g')
    .attr('transform', 'translate(0, ' + height + ')')
    .attr('class', 'marker-axis')
    .call(markerAxis);

  svg.append('g')
    .attr('transform', 'translate(0, ' + height + ')')
      .call(xAxis);

  var reverseLookup = function(objOriginal, comparedValue) {
    var values = Object.keys(objOriginal).map(function (key) {
      return objOriginal[key];
    });

    var index = values.indexOf(comparedValue);

    return Object.keys(objOriginal)[index];
  };

  chart.selectAll('.marker-axis .tick line')
    .attr('class', function(node) {
      return reverseLookup(markers, node);
    });
};

