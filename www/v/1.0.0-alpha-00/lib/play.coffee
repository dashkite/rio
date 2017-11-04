import $ from "./dom-helpers.js"

benchmark = (description, f) ->
  start = performance.now()
  do f
  end = performance.now()
  console.log "#{description}: #{end - start}ms"

# provisionally define until module loads
innerHTML = (el, html) -> el.innerHTML = html

loading = do ->

  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]

define = (name, description) ->

  class Component extends HTMLElement

    constructor: ->
      super()
      @attachShadow mode: "open"
      @wrapData()
      @isReady = new Promise (@ready) =>

    connectedCallback: ->
      await loading
      @bindEvents()
      # I'm not sure why, but we need to add <main>
      # before calling importStyles, otherwise
      # the styles may be ignored
      @addMain()
      @importStyles()
      @ready true
      @render()

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
        @emit "change"
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
      benchmark "Import styles for #{name}", =>
        re = ///#{name}\s+:host\s+///g
        imports = []
        for sheet in document.styleSheets when sheet.rules?
          for rule in sheet.rules
            if rule.cssText.match re
              imports.push rule.cssText.replace re, ""
        if imports.length > 0
          el = document.createElement "style"
          el.textContent =  imports.join "\n"
          @shadowRoot.appendChild el

    addMain: ->
      @main = document.createElement("main")
      @shadowRoot.appendChild @main

    render: ->
      if await @isReady
        benchmark "Render #{name}", =>
          if @template?
            innerHTML @main, @template @data

    emit: (name) ->
      if await @isReady
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
