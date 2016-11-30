$(document).ready( function() {
  var hardCap = d3.select(".chart").attr("data-hard-cap");
  var activeBookings = d3.select(".chart").attr("data-active-bookings");

  var margin = { top: 100, right: 20, bottom: 60, left: 40 };
  var width = 800 - margin.left - margin.right;
  var height = 200 - margin.top - margin.bottom;

  var svg = d3.select('.chart')
    .append('svg')
      .attr('height', height + margin.top + margin.bottom)
      .attr('width', width + margin.left + margin.right)
    .append('g')
      .attr('transform', `translate(${margin.left}, ${margin.top})`);

  var xScale = d3.scaleLinear()
          .domain([0, hardCap])
          .range([0, width])

  var bar = svg.append('rect')
    .attr('width', xScale(activeBookings))
    .attr('height', height);

  svg.append('text')
    .text(activeBookings)
    .attr('x', xScale(activeBookings) / 2)
    .attr('y', height/2)
    .attr('text-anchor', 'middle')

  var xAxis = d3.axisBottom(xScale);

  svg.append('g')
    .attr('transform', `translate(0, ${height})`)
      .call(xAxis);
} );
