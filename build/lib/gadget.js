var Gadget, _on, base, gadget, isGadget, isGadgetClass, isHostSelector, parse, style;

import { HTML } from "./vhtml";

({ style, parse } = HTML);

import { innerHTML } from "diffhtml";

import { prototype, isKind, isTransitivePrototype, isString, isFunction, isAsyncFunction, isObject, properties } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

base = function (x) {
  return prototype(x.constructor);
};

Gadget = function () {
  class Gadget {
    constructor(dom) {
      this.dom = dom;
    }

    static properties(description) {
      return properties(this.prototype, description);
    }

    async connect() {
      await this.initialize();
      return this.ready();
    }

    initialize() {
      this.initialize = function () {};
      return this.events();
    }

    ready() {
      return this.render();
    }

    render() {
      var html;
      if (this.template != null) {
        html = this.template(this);
        if (isString(html)) {
          // convert to vdom if necessary...
          html = parse(html);
        }
        // ...so we can add imported styles
        html.push(style(this.styles));
        // remember, this diffs and patches
        return this.html = html;
      } else {
        return this.html = "";
      }
    }

    // defined using multimethods, see below
    on(description) {
      return _on(this, description);
    }

    dispatch(name) {
      return this.shadow.dispatchEvent(new Event(name, {
        bubbles: true,
        cancelable: false,
        // allow to bubble up from shadow DOM
        composed: true
      }));
    }

    events() {
      return this.on({
        host: {
          change: event => {
            this.render();
            return event.stopPropagation();
          }
        }
      });
    }

    static events(description) {
      this.prototype.events = function () {
        // can't use super here b/c JS doesn't allow it
        // outside of method definitions
        base(this).prototype.events.call(this);
        return this.on(description);
      };
      return this;
    }

    static observe(descriptors) {
      var key, value;
      for (key in descriptors) {
        value = descriptors[key];
        properties(this.prototype, {
          [`${key}`]: function (value) {
            return {
              get: function () {
                return value;
              },
              set: function (_value) {
                value = _value;
                this.dispatch("change");
                return value;
              }
            };
          }(value)
        });
      }
      return this;
    }

    static register(tag1) {
      var self;
      this.tag = tag1;
      self = this;
      self.Component = class extends HTMLElement {
        constructor() {
          super();
          this.attachShadow({
            mode: "open"
          });
          this.gadget = new self(this);
        }

        connectedCallback() {
          return this.gadget.connect();
        }

      };
      requestAnimationFrame(function () {
        return customElements.define(self.tag, self.Component);
      });
      return this;
    }

    static async select(selector) {
      var element, i, len, ref, results, tag;
      results = [];
      ref = document.querySelectorAll(selector);
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        try {
          tag = element.tagName.toLowerCase();
          await customElements.whenDefined(tag);
          if (element.gadget != null) {
            results.push(element.gadget);
          }
        } catch (error) {}
      }
      return new this.Collection(results);
    }

    static pipe(...gadgets) {
      // TODO: use Fairmont Reactor
      return gadgets.reduce(function (source, target) {
        source.on({
          change: function () {
            return target.value = source.value;
          }
        });
        return target;
      });
    }

    static ready(f) {
      document.addEventListener("DOMContentLoaded", f);
      return this;
    }

  };

  properties(Gadget.prototype, {
    super: {
      get: function () {
        return prototype(prototype(this));
      }
    },
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
        return innerHTML(this.shadow, value);
      }
    },
    styles: {
      get: function () {
        var i, j, len, len1, re, ref, ref1, rule, sheet, styles;
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

  Gadget.Collection = class {
    constructor(gadgets1) {
      this.gadgets = gadgets1;
      return new Proxy(this, {
        get: function (target, property) {
          var first, gadgets;
          ({ gadgets } = target);
          if (isFunction(Gadget.prototype[property])) {
            return function () {
              var gadget, i, len, results1;
              results1 = [];
              for (i = 0, len = gadgets.length; i < len; i++) {
                gadget = gadgets[i];
                results1.push(gadget[property](...arguments));
              }
              return results1;
            };
          } else if (isAsyncFunction(Gadget.prototype[property])) {
            return function () {
              var gadget;
              return Promise.all(function () {
                var i, len, results1;
                results1 = [];
                for (i = 0, len = gadgets.length; i < len; i++) {
                  gadget = gadgets[i];
                  results1.push(gadget[property](...arguments));
                }
                return results1;
              }.apply(this, arguments));
            };
          } else {
            [first] = gadgets;
            return first != null ? first[property] : void 0;
          }
        },
        set: function (target, property, value) {
          var gadget, gadgets, i, len;
          ({ gadgets } = target);
          for (i = 0, len = gadgets.length; i < len; i++) {
            gadget = gadgets[i];
            gadget[property] = value;
          }
          return true;
        }
      });
    }

  };

  return Gadget;
}();

// Selector-based event handling
isGadget = isKind(Gadget);

isHostSelector = function (s) {
  return s === "host";
};

_on = Method.create({
  default: function () {} // ignore bad descriptions
});

// simple event handler with no selector
Method.define(_on, isGadget, isString, isFunction, function (gadget, name, handler) {
  return gadget.shadow.addEventListener(name, handler.bind(gadget));
});

// event handler using a selector, event name, and handler
Method.define(_on, isGadget, isString, isString, isFunction, function (gadget, selector, name, handler) {
  return gadget.shadow.addEventListener(name, function (event) {
    if (event.target.matches(selector)) {
      return handler.call(gadget, event);
    }
  });
});

// event handler using special host selector (that's the shadow root)
// must be defined after generic selector otw this never gets called
Method.define(_on, isGadget, isHostSelector, isString, isFunction, function (gadget, selector, name, handler) {
  return gadget.shadow.addEventListener(name, function (event) {
    if (event.target === gadget.shadow) {
      return handler.call(gadget, event);
    }
  });
});

// a dictionary of event handlers for a selector
Method.define(_on, isGadget, isString, isObject, function (gadget, selector, description) {
  var handler, name, results1;
  results1 = [];
  for (name in description) {
    handler = description[name];
    results1.push(_on(gadget, selector, name, handler));
  }
  return results1;
});

// a dictionary of event handlers of some kind—our starting point
Method.define(_on, isGadget, isObject, function (gadget, description) {
  var key, results1, value;
  results1 = [];
  for (key in description) {
    value = description[key];
    results1.push(_on(gadget, key, value));
  }
  return results1;
});

isGadgetClass = function (x) {
  return x === Gadget || isTransitivePrototype(Gadget, x);
};

// gadget creation function if you want less clutter
gadget = Method.create({
  default: function () {
    throw new TypeError("gadget: bad arguments");
  }
});

Method.define(gadget, isGadgetClass, isObject, function (base, description) {
  if (description.ready == null) {
    description.ready = function () {};
  }
  return function () {
    var _Class;

    _Class = class extends base {
      ready() {
        super.ready();
        return description.ready.call(this);
      }

    };

    _Class.prototype.template = description.template;

    _Class.register(description.name);

    if (description.events != null) {
      _Class.events(description.events);
    }

    if (description.observe != null) {
      _Class.observe(description.observe);
    }

    if (description.properties != null) {
      _Class.properties(description.properties);
    }

    return _Class;
  }();
});

Method.define(gadget, isObject, function (description) {
  return gadget(Gadget, description);
});

export { gadget, Gadget };