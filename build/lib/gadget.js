var Gadget;

import { properties } from "fairmont-helpers";

import { events } from "./events";

import { mixins } from "./mixins";

Gadget = function () {
  class Gadget {
    static properties(description) {
      return properties(this.prototype, description);
    }

    static mixins(list) {
      return mixins(this, list);
    }

    static on(description) {
      return this.events.push(description);
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

  properties(Gadget, {
    tag: {
      set: function (tag) {
        var self;
        properties(this, {
          tag: {
            value: tag
          }
        });
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
    }
  });

  Gadget.events = [];

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