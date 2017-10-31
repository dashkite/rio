import { innerHTML } from "https://diffhtml.org/es"
import $ from "./dom-helpers.js"

define = (name, description) ->

  class Component extends HTMLElement

    constructor: ->
      super()

    connectedCallback: ->
      @attachShadow mode: "open"
      do (name=null) =>
        if @events?
          for selector, events of @events
            for name, handler of events
              do (name, handler) =>
                h = handler.bind @
                g = (event) ->
                  {target} = event
                  (h event) if target.matches selector
                @shadowRoot
                .addEventListener name, g, true

      if @data?
        # quick pass in case there are any getters or setters
        # TODO make this recursive
        # TODO make sure get/set are functions
        # TODO use JSON schema to allow validation?
        # TODO allow observe: false?
        for key, value of @data
          if value.get? || value.set?
            Object.defineProperty @data, key, value
        validator = set: (object, key, value) =>
          object[key] = value
          @render()
          true
        @data = new Proxy @data, validator

      # initial render
      @render()

      # copy stylesheet from parent
      if (link = $ "link[rel='stylesheet']", @)
        @shadowRoot.appendChild link
      if (style = $ "style", @)
        @shadowRoot.appendChild style

      # attach imports to document
      for sheet in @shadowRoot.styleSheets when sheet.rules?
        for rule in sheet.rules when rule.type == CSSRule.IMPORT_RULE
          document.styleSheets[0].insertRule rule.cssText, 0

      @ready?()

    render: ->
      if @template?
        innerHTML @shadowRoot, @template @data

    emit: (name) ->
      @dispatchEvent new Event name,
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true


  for key, value of description
    Component.prototype[key] = value

  customElements.define name, Component


export { define }
