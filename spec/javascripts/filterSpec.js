describe('Filtering by demographics', () => {
  describe('#lengthOfStay', () => {
    it('returns the correct length of stay for an active booking', () => {
      const booking = {
        booking_date_time: '2016-12-11T13:13:17.000Z',
        release_date_time: null
      };

      const table = new Filter([]);

      let expectedDifference = new Date() -
        new Date(booking.booking_date_time);
      expect(table.lengthOfStay(booking)).toBeCloseTo(expectedDifference);
    });

    it('returns the correct length of stay for an inactive booking', () => {
      const booking = {
        booking_date_time: '2016-12-11T13:13:17.000Z',
        release_date_time: '2018-12-11T13:13:17.000Z'
      };

      const table = new Filter([]);

      let expectedDifference = new Date(booking.release_date_time) -
        new Date(booking.booking_date_time);
      expect(table.lengthOfStay(booking)).toEqual(expectedDifference);
    });
  });

  describe('#distanceOfTimeInWords', () => {
    it('can handle days', () => {
      const table = new Filter([]);

      const duration = new Date(2016, 1, 3) - new Date(2016, 1, 1);
      expect(table.distanceOfTimeInWords(duration)).toEqual('2 days');
    });

    it('can handle months', () => {
      const table = new Filter([]);

      const duration = new Date(2016, 3, 2) - new Date(2016, 1, 1);
      expect(table.distanceOfTimeInWords(duration)).toEqual('2 months');
    });

    it('can handle a year', () => {
      const table = new Filter([]);

      const duration = new Date(2017, 1, 1) - new Date(2016, 1, 1);
      expect(table.distanceOfTimeInWords(duration)).toEqual('about 1 year');
    });

    it('can handle multiple months', () => {
      const table = new Filter([]);

      const duration = new Date(2018, 1, 1) - new Date(2016, 1, 1);
      expect(table.distanceOfTimeInWords(duration)).toEqual('over 2 years');
    });
  });
});
