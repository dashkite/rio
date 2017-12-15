var autorender, composable, mixins, observe, parse, properties, property, style, styles, template, vdom, zen;

import { HTML } from "./vhtml";

import { innerHTML } from "diffhtml";

import { isArray, isObject, isFunction, properties as _properties } from "fairmont-helpers";

import { Method } from "fairmont-multimethods";

({ style, parse } = HTML);

properties = function (description) {
  return function (type) {
    return _properties(type.prototype, description);
  };
};

property = function (key, value) {
  return function (type) {
    return _properties(type.prototype, {
      [`${key}`]: description
    });
  };
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
          return handler.call(this, x);
        }
      };
    }(value)));
  }
  return results;
};

composable = observe({
  value: ""
}, function () {
  return this.target.dispatch("change");
});

vdom = function (type) {
  return properties(type.prototype, {
    html: {
      get: function () {
        return this.shadow.innerHTML;
      },
      set: function (html) {
        vdom = isString(html) ? parse(html) : html;
        if (this.styles) {
          vdom.push(style(this.styles));
        }
        return innerHTML(this.shadow, value);
      }
    }
  });
};

autorender = function (type) {
  return type.events.push({
    change: function () {
      return this.render();
    }
  });
};

template = function (type) {
  return type.prototype.render = function () {
    return this.html(this.template(this));
  };
};

styles = function (type) {
  return properties(type.prototype, {
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
};

zen = [composable, vdom, autorender, styles, template];

mixins = Method.create({
  default: function () {
    return new TypeError("mixins: bad argument");
  }
});

Method.define(mixins, isObject, isFunction, function (type, f) {
  return f(type);
});

Method.define(mixins, isObject, isArray, function (type, mixins) {
  var i, len, mixin, results;
  results = [];
  for (i = 0, len = mixins.length; i < len; i++) {
    mixin = mixins[i];
    results.push(mixins(type, mixin));
  }
  return results;
});

export { property, properties, observe, composable, vdom, autorender, template, styles,
// presets
zen,
// application
mixins };