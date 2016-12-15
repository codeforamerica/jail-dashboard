class FilterTable {
  constructor(data, targetElement) {
    this.data = data;
    this.targetElement = targetElement;

    this.dimensions = {};
  }

  render(targetElement) {
    var bookings = crossfilter(this.data);

    var all = bookings.groupAll();

    this.dimensions.status = bookings.dimension(d => d.status);

    this.
      targetElement.
      append('button').
      text('sentenced').
      on('click', () => {
        this.dimensions.status.filter('Sentenced');
        this.update();
      })

    this.
      targetElement.
      append('button').
      text('pre-trial').
      on('click', () => {
        this.dimensions.status.filter('Pre-trial');
        this.update();
      })

    this.
      targetElement.
      append('button').
      text('all').
      on('click', () => {
        this.dimensions.status.filterAll();
        this.update();
      })

    this.update();
  }

  update() {
    let update = this.targetElement
      .selectAll('.row')
      .data(this.dimensions.status.top(Infinity));

    update.exit().remove();

    let enter = update.enter()
      .append('div')
      .attr('class', 'row');

    update.merge(enter)
      .text(d => `${d.first_name} ${d.last_name}, ${d.jms_person_id}, ${d.status}`);
  }
}
