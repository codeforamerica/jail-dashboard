window.PopulationCapacityChart = function(args) {
  var reverseLookup = function(objOriginal, comparedValue) {
    var values = Object.keys(objOriginal).map(function (key) {
      return objOriginal[key];
    });

    var index = values.indexOf(comparedValue);

    return Object.keys(objOriginal)[index];
  };

  var exports = {
    graphMaximumX: function() {
      return Math.max(args.active_bookings, args.markers.hard_cap);
    },

    numberOverThreshold: function() {
      var passedMarkers = Object.values(args.markers).filter((markerAmount) => {
        return markerAmount < args.active_bookings;
      });

      if(passedMarkers.length === 0) {
        return null;
      }

      var largestPassedThreshold = Math.max(...passedMarkers);

      return {
        amountOver: args.active_bookings - largestPassedThreshold,
        threshold: reverseLookup(args.markers, largestPassedThreshold)
      };
    },

    render: function(targetElement) {
      var markerValues = [];

      for (var key in args.markers) {
        markerValues = markerValues.concat(args.markers[key]);
      }

      var margin = { top: 20, right: 20, bottom: 60, left: 40 };
      var width = 800 - margin.left - margin.right;
      var height = 200 - margin.top - margin.bottom;

      var svg = targetElement
        .append('svg')
          .attr('height', height + margin.top + margin.bottom)
          .attr('width', width + margin.left + margin.right)
        .append('g')
          .attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')');

      var xScale = d3.scaleLinear()
              .domain([0, this.graphMaximumX()])
              .range([0, width]);

      svg.append('rect')
        .attr('class', 'active-bookings')
        .attr('width', xScale(args.active_bookings))
        .attr('y', height / 2)
        .attr('height', height / 2);

      svg.append('rect')
        .attr('class', 'red-zone')
        .attr('width', xScale(args.markers.hard_cap - args.markers.red_zone_start))
        .attr('x', xScale(args.markers.red_zone_start))
        .attr('height', height);

      svg.append('text')
        .text(args.active_bookings)
        .attr('x', xScale(args.active_bookings) / 2)
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

      targetElement.selectAll('.marker-axis .tick line')
        .attr('class', function(node) {
          return reverseLookup(args.markers, node);
        });
    }
  };

  return exports;
};

