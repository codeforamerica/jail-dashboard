class HistoricalChart {
  constructor(data, chartElement) {
    this.data = data;
    this.chartElement = chartElement;
    this.dimensions = {};
    this.filters = {};
    this.counts = [];
  }

  filtersUpdated(data) {
    this.data = data;
    this.update();
  }

  render() {

    function setDates() {
      var latestDate = new Date();
      var counterDate = new Date(2016, 1, 1);
      var week;
      var dates = [counterDate];

      while (latestDate >= counterDate) {
        week = counterDate.getDate() + 7
        counterDate = new Date(counterDate.setDate(++week));
        dates.push(counterDate);
      }
      return dates;
    }

    var datesArray = setDates();

    var bookings = crossfilter(this.data);

    function getCounts() {
      var counts = [];
      datesArray.forEach(function (date) {
        let currentDate = date;
        var bookingDateTime = bookings.dimension(d => d.booking_date_time);
        var releaseDateTime = bookings.dimension(d => d.release_date_time);
        bookingDateTime.filterFunction(d => d < currentDate);
        releaseDateTime.filterFunction(d => d == null || d > currentDate);
        counts.push(bookings.groupAll().reduceCount().value());
        bookingDateTime.dispose()
        releaseDateTime.dispose()
      });
      return counts;
    }
    this.counts = getCounts()

    var data = [{
      date: datesArray,
      count: this.counts
    }];

    var xy_chart = d3_xy_chart()

    var svg = d3.select(".historical").append("svg")
      .datum(data)
      .call(xy_chart);

    function d3_xy_chart() {
      var width = document.getElementsByClassName("historical")[0].getBoundingClientRect().width,
        height = 480;

      function chart(selection) {
        selection.each(function (datasets) {

          var margin = {
              top: 20,
              right: 30,
              bottom: 30,
              left: 30
            },
            innerwidth = width - margin.left - margin.right,
            innerheight = height - margin.top - margin.bottom;

          var x_scale = d3.scaleTime()
            .range([0, innerwidth])
            .domain([d3.min(datasets, function (d) {
                return d3.min(d.date);
              }),
              d3.max(datasets, function (d) {
                return d3.max(d.date);
              })
            ]);

          var y_scale = d3.scaleLinear()
            .range([innerheight, 0])
            .domain([d3.min(datasets, function (d) {
                return d3.min(d.count);
              }),
              d3.max(datasets, function (d) {
                return d3.max(d.count);
              })
            ]);



          var x_axis = d3.axisBottom(x_scale);

          var y_axis = d3.axisLeft(y_scale);



          var draw_line = d3.line()
            .x(d => x_scale(d[0]))
            .y(d => y_scale(d[1]));

          var svg = d3.select(this)
            .attr("width", width)
            .attr("height", height)
            .append("g")
            .attr("transform", `translate(${margin.left},${margin.top})`);


          svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + innerheight + ")")
            .call(x_axis)
            .append("text")
            .attr("dy", "-.71em")
            .attr("x", innerwidth)
            .style("text-anchor", "end");

          svg.append("g")
            .attr("class", "y axis")
            .call(y_axis)
            .append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", "0.71em")
            .style("text-anchor", "end");

          var data_lines = svg.selectAll(".d3_xy_chart_line")
            .data(datasets.map(d => d3.zip(d.date, d.count)))
            .enter().append("g")
            .attr("class", "d3_xy_chart_line");

          data_lines.append("path")
            .attr("class", "line")
            .attr("d", d => draw_line(d))
            .attr("fill", "white")
            .attr("stroke", "lightseagreen");

        });
      }

      chart.width = function (value) {
        if (!arguments.length) return width;
        width = value;
        return chart;
      };

      chart.height = function (value) {
        if (!arguments.length) return height;
        height = value;
        return chart;
      };

      return chart;
    }
  }

  update() {
    this.redraw(this.chartElement);
  }

  redraw() {
    var svg = document.getElementsByClassName("historical")[0];
    while (svg.firstChild) {
      svg.removeChild(svg.firstChild);
    }
    this.render();
  }
}