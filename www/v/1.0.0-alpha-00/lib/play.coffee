import $ from "./dom-helpers.js"

innerHTML = null
loading = do ->
  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]

define = (name, description) ->

  log = (description) -> console.log "[ #{name} ] #{description}"

  benchmark = (description, f) ->
    start = performance.now()
    f()
    end = performance.now()
    log "#{description}: #{end - start}ms"

  Component = class extends HTMLElement

    constructor: ->
      super()
      benchmark "construction", =>
        @attachShadow mode: "open"

    connectedCallback: ->
      benchmark "connecting", =>
        @initialize()

    initialize: ->
      @initialize = ->
      benchmark "initialization", =>
        @wrapData()
        @bindEvents()
        # I'm not sure why, but we need to add <main>
        # before calling importStyles, otherwise
        # the styles may be ignored
        @addMain()
        @importStyles()
        await loading
        await @render()
        @ready?()

    wrapData: ->
      @data ?= {}
      @data.$ = @
      for key, value of @data
        if value.get? || value.set?
          Object.defineProperty @data, key, value
      observer = set: (object, key, value) =>
        object[key] = value
        @dispatch "change"
        true
      @data = new Proxy @data, observer

    bindEvents: ->
      do (name=null) =>
        if @events?
          for selector, events of @events
            for name, handler of events
              do (handler) =>
                h = handler.bind @
                g = if selector == "host"
                  (event) ->
                    h event
                else
                  (event) ->
                    {target} = event
                    (h event) if target.matches selector
                @shadowRoot.addEventListener name, g, true

    importStyles: ->
      benchmark "import styles", =>
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
      await @beforeRender?()
      benchmark "render", =>
        innerHTML @main, @template? @data
      await @afterRender?()

    dispatch: (name) ->
      await loading
      log "dispatch '#{name}'"
      @shadowRoot.dispatchEvent new Event name,
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true

  for key, value of description
    Component.prototype[key] = value

  customElements.define name, Component

  Component

export { define }
