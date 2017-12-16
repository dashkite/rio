var gadget, isGadgetClass;

import { isObject, isKind, isFunction, isTransitivePrototype } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

import { Gadget } from "./gadget";

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
    if (isFunction(base[key])) {
      results.push(base[key](value));
    } else {
      results.push(base[key] = value);
    }
  }
  return results;
});

Method.define(gadget, isObject, function (description) {
  return gadget(class extends Gadget {}, description);
});

Method.define(gadget, isKind(HTMLElement), async function (element) {
  var tag;
  tag = element.tagName.toLowerCase();
  await customElements.whenDefined(tag);
  return element.gadget;
});

export { gadget };