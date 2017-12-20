var Type, autorender, calypso, componentAccessors, composable, domEvented, evented, given, instance, mix, observe, properties, property, styles, tag, tee, template, vdom, zen;

import { HTML } from "./vhtml";

import { innerHTML } from "diffhtml";

import { isString, isObject, isArray, isKind, isFunction, properties as _properties } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

Type = {
  create: function (type) {
    if (type != null) {
      return new type();
    }
  },
  define: function (parent = Object) {
    return class extends parent {};
  }
};

mix = Method.create({
  default: function () {
    return new TypeError("mixins: bad argument");
  }
});

Method.define(mix, isKind(Object), isFunction, function (type, mixin) {
  return mixin(type);
});

Method.define(mix, isKind(Object), isArray, function (type, list) {
  return list.reduce(function (type, mixin) {
    return mix(type, mixin);
  }, type);
});

// adapts a function to always return its first argument
tee = function (f) {
  return function (first, ...rest) {
    f(first, ...rest);
    return first;
  };
};

// call f with value and return value
given = function (value, f) {
  f(value);
  return value;
};

properties = function (description) {
  return tee(function (type) {
    return _properties(type.prototype, description);
  });
};

property = function (key, value) {
  return properties({
    [key]: value
  });
};

observe = function (description, handler) {
  var key, results, value;
  results = [];
  for (key in description) {
    value = description[key];
    results.push(property(key, function (value) {
      return {
        get: function () {
          return value;
        },
        set: function (x) {
          value = x;
          return handler.call(this, value);
        }
      };
    }(value)));
  }
  return results;
};

composable = [observe({
  value: ""
}, function () {
  return this.dispatch("change");
}), tee(function (source) {
  return source.prototype.pipe = function (target) {
    return this.on({
      change: function () {
        return target.value = this.value;
      }
    });
  };
})];

evented = function (implementation) {
  return tee(function (type) {
    Object.assign(type, {
      on: function (description) {
        return (this.events != null ? this.events : this.events = []).push(description);
      }
    });
    return Object.assign(type.prototype, implementation);
  });
};

domEvented = tee(function (type) {
  Object.assign(type, {
    on: function (description) {
      return (this.events != null ? this.events : this.events = []).push(description);
    },
    ready: function (f) {
      var g;
      g = function (event) {
        event.target.removeEventListener(event.type, g);
        return f.call(this, event);
      };
      return this.on({
        initialize: g
      });
    }
  });
  return Object.assign(type.prototype, {
    on: function (events) {
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
          if (event.target.matches(selector)) {
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
      return function (description) {
        return events(this, description);
      };
    }(null),
    dispatch: function (name, { local } = {
      local: false
    }) {
      return this.shadow.dispatchEvent(new Event(name, {
        bubbles: true,
        cancelable: false,
        // allow to bubble up from shadow DOM
        composed: !local
      }));
    },
    initialize: function () {
      this.initialize = function () {};
      this.on(this.constructor.events);
      return this.dispatch("initialize", {
        local: true
      });
    }
  });
});

vdom = properties({
  html: {
    get: function () {
      return this.shadow.innerHTML;
    },
    set: function ({ style, parse }) {
      return function (html) {
        vdom = isString(html) ? parse(html) : html;
        vdom.push(style(this.styles));
        return innerHTML(this.shadow, vdom);
      };
    }(HTML)
  }
});

autorender = tee(function (type) {
  type.on({
    change: function () {
      return this.render();
    }
  });
  return type.prototype.ready = function () {
    return this.render();
  };
});

template = tee(function (type) {
  return type.prototype.render = function () {
    return this.html = this.constructor.template(this);
  };
});

styles = properties({
  styles: {
    get: function () {
      var i, j, len, len1, re, ref, ref1, rule, sheet;
      styles = "";
      re = RegExp(`${this.tag}\\s+:host\\s+`, "g");
      ref = document.styleSheets;
      for (i = 0, len = ref.length; i < len; i++) {
        sheet = ref[i];
        if (sheet.rules != null) {
          ref1 = sheet.rules;
          for (j = 0, len1 = ref1.length; j < len1; j++) {
            rule = ref1[j];
            if (rule.cssText.match(re)) {
              styles += rule.cssText.replace(re, "") + "\n";
            }
          }
        }
      }
      return styles;
    }
  }
});

componentAccessors = properties({
  tag: {
    get: function () {
      return this.constructor.tag;
    }
  },
  shadow: {
    get: function () {
      return this.dom.shadowRoot;
    }
  },
  html: {
    get: function () {
      return this.shadow.innerHTML;
    },
    set: function (value) {
      return this.shadow.innerHTML = value;
    }
  }
});

tag = function (name) {
  return tee(function (type) {
    type.tag = name;
    type.Component = class extends HTMLElement {
      constructor() {
        super();
        this.gadget = new type(this);
        this.attachShadow({
          mode: "open"
        });
      }

      connectedCallback() {
        return this.gadget.connect();
      }

    };
    // allow the gadget to be fully defined
    // before registering it...
    return requestAnimationFrame(function () {
      return customElements.define(type.tag, type.Component);
    });
  });
};

instance = function (description) {
  return tee(function (type) {
    return Object.assign(type.prototype, description);
  });
};

calypso = [vdom, styles, template];

zen = [calypso, composable, autorender];

export { property, properties, observe, composable, evented, domEvented, vdom, autorender, template, styles, tag, componentAccessors, instance,
// presets
calypso, zen,
// application
mix };