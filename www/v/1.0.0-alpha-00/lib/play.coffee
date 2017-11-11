import {style, parse, }

innerHTML = null
loading = do ->
  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]

isString = (value) -> (Object.getPrototypeOf value) == String::

class Play

  constructor: (name, @dom) ->
    Object.defineProperties @,
      name:
        enumerable: true
        value: name
      shadow:
        enumerable: true
        get: => @dom.shadowRoot
      innerHTML:
        enumerable: true
        get: => @shadow.innerHTML
        set: (value) => innerHTML @shadow, value

  connect: ->
    @benchmark "initialization", =>
      @initialize()

  initalize: ->
    @initialize = ->
    @benchmark "initialization", =>
      @__buildData()
      @__bindEvents()
      @__importStyles()
      await Play.loading
      await @render()
      @ready?()

  render: ->
    if @template?
      @benchmark "render", =>
        html = @template @data
        # convert to vdom if necessary...
        html = parse rendered if isString html
        # ...so we can add imported styles
        html.push style @sheet.join "\n"
        # remember, this diffs and patches
        @innerHTML = html

  dispatch: (name) ->
    await Play.loading
    @log "dispatch '#{name}'"
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

  log: (description) -> console.log "[ #{@name} ] #{description}"

  benchmark: (description, f) ->
    start = performance.now()
    f()
    end = performance.now()
    @log "#{description}: #{end - start}ms"

  __buildData: ->
    @data ?= {}
    _proxy = false
    for name, description of @schema
      {type, get, set, proxy, observe} = description
      if set? || get?
        set?.bind @
        get?.bind @
        Object.defineProperty @data, name,
          enumerable: true
          get: get if get?
          set: (value) =>
            # TODO: check thet type
            @data[name] = value
            # TODO: need to use Proxy for deep changes
            @dispatch "change" unless observe == false
            value
      if value?
        @data[name] = value
      if proxy == true && !_proxy
        _proxy = true
        do (name) =>
          Object.defineProperty @, name,
            get: => @data[name]
            set: (value) => @data[name] = value

  __bindEvents: ->
    if @events?
      for selector, events of @events
        for name, handler of events
          do =>
            h = handler.bind @
            g = if selector == "host"
              (event) -> h event
            else
              (event) ->
                {target} = event
                (h event) if target.matches selector
            @shadow.addEventListener name, g, true

  __importStyles: ->
    @benchmark "import styles", =>
      re = ///#{@name}\s+:host\s+///g
      imports = []
      for sheet in document.styleSheets when sheet.rules?
        for rule in sheet.rules
          if rule.cssText.match re
            imports.push rule.cssText.replace re, ""
      @sheet = {imports}


class Gadgets
  constructor: (@gadgets) ->
  on: (handlers) ->
    for gadget in @gadgets
      for event, handler in handlers
        gadget.dom.addEventListener name, handler

Play.select = (selector) ->
  new Gadgets
    for element in (document.querySelectorAll selector) when element.gadget?
      element.gadget


Play.register = (name) ->

  Gadget = @

  class Component extends HTMLElement

    constructor: ->
      super()
      benchmark "construction", =>
        @attachShadow mode: "open"
        @gadget = new Gadget name, @

    connectedCallback: ->
      benchmark "connecting", =>
        @gadget.connect()

Play.loading = loading

export {Play}
