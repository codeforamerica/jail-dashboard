class FilterTable {
  constructor(data, filters, tableElement, filterElement) {
    this.data = data;
    this.filters = filters;
    this.tableElement = tableElement;
    this.filterElement = filterElement;

    this.dimensions = {};
  }

  render() {
    this.addFilterButtons('status');

    this.table = this.tableElement.append('table')
      .attr('class', 'table table-striped table-responsive');

    let header = this.table.append('thead').append('tr');

    header.append('th').text('Name');
    header.append('th').text('JMS ID');
    header.append('th').text('Status');

    var bookings = crossfilter(this.data);
    var all = bookings.groupAll();
    this.dimensions.status = bookings.dimension(d => d.status);

    this.body = this.table.append('tbody')
    this.update();
  }

  addFilterButtons(dimensionName) {
    let filterGroup = this
      .filterElement
      .append('div')
      .attr('class', `filter-${dimensionName}`);

    filterGroup.append('h3')
      .text(`Filter by ${dimensionName}`)

    this.filters[dimensionName].forEach((filterName) => {
        filterGroup
        .append('button')
        .text(filterName)
        .on('click', () => {
            this.dimensions[dimensionName].filter(filterName);
            this.update();
            })
        })

    filterGroup
      .append('button')
      .text('all')
      .on('click', () => {
        this.dimensions[dimensionName].filterAll();
        this.update();
      })
  }

  update() {
    let update = this.body
      .selectAll('tr')
      .data(this.dimensions.status.top(Infinity));

    update.exit().remove();

    let enter = update.enter()
      .append('tr');

    update.merge(enter)
      .html(d => `<td>${d.first_name} ${d.last_name}</td><td>${d.jms_person_id}</td><td>${d.status}</td>`);
  }
}
