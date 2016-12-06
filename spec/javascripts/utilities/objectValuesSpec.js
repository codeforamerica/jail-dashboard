describe('objectValues()', () => {
  it('returns an array of values for a given object', () => {
    const myObject = {
      thing: 1,
      otherThing: 2
    };

    expect(objectValues(myObject)).toEqual([1,2]);
  });
});
