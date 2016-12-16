class FilterTable {
  constructor(data, tableElement, filterElement) {
    this.data = data;
    this.tableElement = tableElement;
    this.filterElement = filterElement;

    this.dimensions = {};
  }

  render() {
    this.addFilterButtons();

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

  addFilterButtons() {
    let statusFilters = this
      .filterElement
      .append('div');

    statusFilters
      .append('button')
      .text('sentenced')
      .on('click', () => {
        this.dimensions.status.filter('Sentenced');
        this.update();
      })

    statusFilters
      .append('button')
      .text('pre-trial')
      .on('click', () => {
        this.dimensions.status.filter('Pre-trial');
        this.update();
      })

    statusFilters
      .append('button')
      .text('all')
      .on('click', () => {
        this.dimensions.status.filterAll();
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
