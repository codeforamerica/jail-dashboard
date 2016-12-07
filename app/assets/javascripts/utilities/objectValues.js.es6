let objectValues = (obj) => {
  let values = [];

  for(let key in obj) {
    values.push(obj[key]);
  }

  return values;
};
