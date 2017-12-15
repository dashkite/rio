var Gadget;

import { properties } from "fairmont-helpers";

import { events } from "./events.coffee";

import { mixins } from "./mixins.coffee";

Gadget = function () {
  class Gadget {
    static register(tag) {
      var self;
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

    static mixins(list) {
      return mixins(this, list);
    }

    constructor(dom) {
      this.dom = dom;
    }

    async connect() {
      await this.initialize();
      return this.ready();
    }

    initialize() {
      this.initialize = function () {};
      this.on(this.constructor.events);
      return this.dispatch('initialize');
    }

    ready() {}

    on(description) {
      return events(this);
    }

    dispatch(name) {
      return this.shadow.dispatchEvent(new Event(name, {
        bubbles: true,
        cancelable: false,
        // allow to bubble up from shadow DOM
        composed: true
      }));
    }

  };

  Gadget.events = [];

  properties(Gadget.prototype, {
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