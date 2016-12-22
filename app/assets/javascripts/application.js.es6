// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require crossfilter2
//= require d3
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

window.runApplication = () => {
  const chartElement = d3.select('.chart');

  const chart = new PopulationCapacityChart(gon.population_capacity_chart);
  chart.render(chartElement);

  d3.select(window).on('resize', () => chart.redraw(chartElement));

  const peopleData = gon.crossfilter_data
  const filter = new FilterTable(
    peopleData,
    gon.filters,
    d3.select('.filtered-people'),
    d3.select('.filters'),
  );

  const historical = new HistoricalChart(
    d3.select('.historical')
  );

  filter.onUpdate(data => historical.filtersUpdated(data));
  filter.render();
};
