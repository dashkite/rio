import { innerHTML } from "https://diffhtml.org/es"
import $ from "./dom-helpers.js"

define = (name, description) ->

  class Component extends HTMLElement

    constructor: ->
      super()
      @attachShadow mode: "open"
      @wrapData()

    connectedCallback: ->
      @bindEvents()
      @render()
      @importStyles()
      # initial render
      @ready?()

    wrapData: ->
      @data ?= {}
      # quick pass in case there are any getters or setters
      # TODO make this recursive/deep
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

    bindEvents: ->
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

    importStyles: ->
      # copy styles into shadow DOM
      if (link = $ "link[rel='stylesheet']", @)
        @shadowRoot.appendChild link
      if (style = $ "style", @)
        @shadowRoot.appendChild style

      # attach imports to document
      # TODO: this should come after the render
      # TODO: what if this array is empty?
      if @shadowRoot.styleSheets?
        for sheet in @shadowRoot.styleSheets when sheet.rules?
          for rule in sheet.rules when rule.type == CSSRule.IMPORT_RULE
            # TODO: don't depend on a stylesheet already existing
            document.styleSheets[0].insertRule rule.cssText, 0

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
