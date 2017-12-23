var Gadget, gadget, helper, helpers, isDerived;

import { Method } from "fairmont-multimethods";

import { isObject, isKind } from "fairmont-helpers";

import { evented, accessors, tag, assign, observe, property, properties } from "./mixins";

Gadget = class Gadget {
  static define() {
    return mix(class extends Gadget {}, [evented, accessors]);
  }

  constructor(dom) {
    this.dom = dom;
  }

  // initialize is idempotent
  connect() {
    return this.initialize();
  }

};

// adapt mixins for use dynamically
helper = function (mixin) {
  return function (type, value) {
    return mixin(value)(type);
  };
};

helpers = {
  tag: helper(tag),
  mixins: function (type, handler) {
    if (isArray(handler)) {
      handler = pipe(handler);
    }
    return handler(type);
  },
  instance: helper(assign),
  property: helper(property),
  properties: helper(properties),
  observe: helper(observe),
  on: function (type, handler) {
    return type.on(handler);
  },
  ready: function (type, handler) {
    return type.ready(handler);
  }
};

isDerived = function (t) {
  return function (x) {
    return isKind(t, x.prototype);
  };
};

gadget = Method.create({
  default: function () {
    throw new TypeError("gadget: bad arguments");
  }
});

Method.define(gadget, isDerived(Gadget), isObject, function (type, description) {
  var key, results, value;
  results = [];
  for (key in description) {
    value = description[key];
    if (helpers[key] != null) {
      results.push(helpers[key](type, value));
    } else {
      results.push(type[key] = value);
    }
  }
  return results;
});

Method.define(gadget, isObject, function (description) {
  return gadget(Gadget.define(), description);
});

(function (tag) {
  return Method.define(gadget, isKind(HTMLElement), async function (element) {
    tag = element.tagName.toLowerCase();
    await customElements.whenDefined(tag);
    return element.gadget;
  });
})(void 0);

export { gadget, Gadget };