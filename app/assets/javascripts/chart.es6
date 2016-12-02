$(document).ready( function() {
  var chart = d3.select(".chart");

  var parseIntAttr = function(element, attrName) {
    return parseInt(element.attr(attrName), 10)
  }

  var markers = {
    'softCap': parseIntAttr(chart, "data-soft-cap"),
    'redZoneStart': parseIntAttr(chart, "data-red-zone-start"),
    'hardCap':parseIntAttr(chart, "data-hard-cap"),
    'maxPopulation': parseIntAttr(chart, "data-max-population"),
  }

  var activeBookings = parseIntAttr(chart, "data-active-bookings");

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
          .range([0, width])

  var bar = svg.append('rect')
    .attr('class', 'active-bookings')
    .attr('width', xScale(activeBookings))
    .attr('y', height / 2)
    .attr('height', height / 2);

  var redZone = svg.append('rect')
    .attr('class', 'red-zone')
    .attr('width', xScale(markers.hardCap - markers.redZoneStart))
    .attr('x', xScale(markers.redZoneStart))
    .attr('height', height);

  svg.append('text')
    .text(activeBookings)
    .attr('x', xScale(activeBookings) / 2)
    .attr('y', height/2)
    .attr('text-anchor', 'middle')

  var markerAxis = d3.axisTop(xScale)
    .tickSize(height)
    .tickValues(Object.values(markers))

  var xAxis = d3.axisBottom(xScale);

  svg.append('g')
    .attr('transform', 'translate(0, ' + height + ')')
    .attr('class', 'marker-axis')
    .call(markerAxis);

  svg.append('g')
    .attr('transform', 'translate(0, ' + height + ')')
      .call(xAxis);

  var reverseLookup = function(objOriginal, comparedValue) {
    var values = Object.values(objOriginal);

    var index = values.indexOf(comparedValue);

    return Object.keys(objOriginal)[index];
  };

  // Give the marker ticks their classes
  d3.selectAll(".marker-axis .tick line")
    .attr('class', function(node, index) {
      return reverseLookup(markers, node);
    });
  } );
