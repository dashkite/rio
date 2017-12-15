var gadget, isGadgetClass;

isGadgetClass = function (x) {
  return x === Gadget || isTransitivePrototype(Gadget, x);
};

gadget = Method.create({
  default: function () {
    throw new TypeError("gadget: bad arguments");
  }
});

Method.define(gadget, isGadgetClass, isObject, function (base, description) {
  var key, results, value;
  results = [];
  for (key in description) {
    value = description[key];
    results.push(typeof base[key] === "function" ? base[key](value) : void 0);
  }
  return results;
});

Method.define(gadget, isObject, function (description) {
  return gadget(class extends Gadget {}, description);
});

export { gadget };