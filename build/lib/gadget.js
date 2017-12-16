var Gadget;

import { properties } from "fairmont-helpers";

import { events } from "./events";

import { mixins } from "./mixins";

Gadget = function () {
  class Gadget {
    static tag(tag) {
      var self;
      this.tag = tag;
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
      return this.tag;
    }

    static properties(description) {
      return properties(this.prototype, description);
    }

    static mixins(list) {
      return mixins(this, list);
    }

    static on(description) {
      return (this.events != null ? this.events : this.events = []).push(description);
    }

    static ready(f) {
      var g;
      g = function (event) {
        event.target.removeEventListener(event.type, g);
        return f.call(this, event);
      };
      return this.on({
        initialize: g
      });
    }

    constructor(dom) {
      this.dom = dom;
    }

    connect() {
      return this.initialize();
    }

    initialize() {
      this.initialize = function () {};
      this.on(this.constructor.events);
      return this.dispatch("initialize", {
        local: false
      });
    }

    on(description) {
      return events(this, description);
    }

    dispatch(name, { local } = {
      local: true
    }) {
      return this.shadow.dispatchEvent(new Event(name, {
        bubbles: true,
        cancelable: false,
        // allow to bubble up from shadow DOM
        composed: local
      }));
    }

  };

  Gadget.properties({
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

  return Gadget;
}();

export { Gadget };