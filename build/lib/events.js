var events;

import { isString, isObject, isArray, isKind, isFunction, properties as $P, methods as $M } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

events = Method.create({
  default: function () {
    console.log({
      "arguments": arguments
    });
    throw new Error("gadget: bad event descriptor");
  }
});

// simple event handler with no selector
Method.define(events, isKind(Object), isString, isFunction, function (gadget, name, handler) {
  return gadget.shadow.addEventListener(name, handler.bind(gadget));
});

// event handler using a selector, event name, and handler
Method.define(events, isKind(Object), isString, isString, isFunction, function (gadget, selector, name, handler) {
  return gadget.shadow.addEventListener(name, function (event) {
    if (event.target.matches(selector) || event.target.closest(selector) != null) {
      return handler.call(gadget, event);
    }
  });
});

// event handler using special host selector (that's the shadow root)
// must be defined after generic selector otw this never gets called
Method.define(events, isKind(Object), function (s) {
  return s === "host";
}, isString, isFunction, function (gadget, selector, name, handler) {
  return gadget.shadow.addEventListener(name, function (event) {
    if (event.target === gadget.shadow) {
      return handler.call(gadget, event);
    }
  });
});

// a dictionary of event handlers for a selector
Method.define(events, isKind(Object), isString, isObject, function (gadget, selector, description) {
  var handler, name, results;
  results = [];
  for (name in description) {
    handler = description[name];
    results.push(events(gadget, selector, name, handler));
  }
  return results;
});

// a dictionary of event handlers of some kind—our starting point
Method.define(events, isKind(Object), isObject, function (gadget, description) {
  var key, results, value;
  results = [];
  for (key in description) {
    value = description[key];
    results.push(events(gadget, key, value));
  }
  return results;
});

// an array of dictionaries
Method.define(events, isKind(Object), isArray, function (gadget, descriptions) {
  var description, i, len, results;
  results = [];
  for (i = 0, len = descriptions.length; i < len; i++) {
    description = descriptions[i];
    results.push(events(gadget, description));
  }
  return results;
});

export { events };