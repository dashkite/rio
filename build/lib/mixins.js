var $assign, $method, $methods, $properties, $property, accessors, assign, autorender, calypso, composable, evented, method, methods, observe, properties, property, styles, tag, template, vdom, zen;

import { HTML } from "./vhtml";

import { innerHTML } from "diffhtml";

import { isString, properties as $P, methods as $M } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

import { pipe, tee } from "fairmont-core";

import { events } from "./events";

property = properties = function (description) {
  return tee(function (type) {
    return $P(type.prototype, description);
  });
};

$property = $properties = function (description) {
  return tee(function (type) {
    return $P(type, description);
  });
};

method = methods = function (description) {
  return tee(function (type) {
    return $M(type.prototype, description);
  });
};

$method = $methods = function (description) {
  return tee(function (type) {
    return $M(type, description);
  });
};

assign = function (description) {
  return tee(function (type) {
    return Object.assign(type.prototype, description);
  });
};

$assign = function (description) {
  return tee(function (type) {
    return Object.assign(type, description);
  });
};

observe = function (description, handler) {
  return pipe(function () {
    var key, results, value;
    results = [];
    for (key in description) {
      value = description[key];
      results.push(property({
        [key]: function (value) {
          return {
            get: function () {
              return value;
            },
            set: function (x) {
              value = x;
              return handler.call(this, value);
            }
          };
        }(value)
      }));
    }
    return results;
  }());
};

evented = pipe([$methods({
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
}), methods({
  on: function (description) {
    return events(this, description);
  },
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
})]);

accessors = properties({
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

composable = pipe([observe({
  value: ""
}, function () {
  return this.dispatch("change");
}), method({
  pipe: function (target) {
    return this.on({
      change: function () {
        return target.value = this.value;
      }
    });
  }
})]);

vdom = tee(properties({
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
}));

autorender = tee(function (type) {
  type.on({
    change: function () {
      return this.render();
    }
  });
  return type.ready(function () {
    return this.render();
  });
});

template = method({
  render: function () {
    return this.html = this.constructor.template(this);
  }
});

styles = property({
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

calypso = pipe([vdom, styles, template]);

zen = pipe([calypso, composable, autorender]);

export { property, properties, $property, $properties, method, methods, $method, $methods, assign, $assign, observe, evented, accessors, tag, composable, vdom, autorender, template, styles,
// presets
calypso, zen,
// application
mix };