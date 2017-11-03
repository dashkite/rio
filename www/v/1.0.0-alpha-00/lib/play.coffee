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

      @main = document.createElement("main")
      @shadowRoot.appendChild @main
      @importStyles()

      # initial render
      @render()

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

      @hoistDocumentCSS()

      # copy styles into shadow DOM
      if (link = $ "link[rel='stylesheet']", @)
        @shadowRoot.appendChild link
      if (style = $ "style", @)
        @shadowRoot.appendChild style

    # TODO: this should be more selective instead of all import rules
    hoistDocumentCSS: ->
      imports = []
      styles = @.querySelectorAll "style"
      for {sheet} in styles
        for rule in sheet.rules when rule.type == CSSRule.IMPORT_RULE
          imports.push rule.cssText
      if imports.length > 0
        ($ "head").insertAdjacentHTML 'beforeend',
          "<style type='text/css'>#{imports.join "\n"}</style>"

    render: ->
      if @template?
        innerHTML @main, @template @data

    emit: (name) ->
      @dispatchEvent new Event name,
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true


  for key, value of description
    Component.prototype[key] = value

  customElements.define name, Component

  Component

export { define }
