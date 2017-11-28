import HTML from "./vhtml.js"
{style, parse} = HTML

# TODO: import from Fairmont Helpers
isType = (t, x) -> x? && (Object.getPrototypeOf x) == t::
isString = (x) -> isType String, x
isFunction = (x) -> isType Function, x

innerHTML = null
loading = do ->
  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]
  true

class Gadget

  constructor: (@name, @dom) ->

  connect: -> @initialize()

  initialize: ->
    @initialize = ->
    @benchmark "initialization", =>
      @__addEventListeners?()
      @__importStyles()
      await Gadget.loading
      await @render()
      @ready?()

  render: ->
    if @template?
      @benchmark "render", =>
        html = @template @
        # convert to vdom if necessary...
        html = parse html if isString html
        # ...so we can add imported styles
        html.push style @sheet.join "\n"
        # remember, this diffs and patches
        @html = html

  on: (handlers) ->
    for event, handler of handlers
      @shadow.addEventListener event, handler

  dispatch: (name) ->
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

  @register: (name) ->
      self = @
      self.Component = class extends HTMLElement
        constructor: ->
          super()
          @attachShadow mode: "open"
          @gadget = new self name, @
        connectedCallback: -> @gadget.connect()
      requestAnimationFrame ->
        customElements.define name, self.Component

  @Collection: class
    constructor: (@gadgets) -> return new Proxy @,
      get: (target, property) ->
        {gadgets} = target
        if isFunction Gadget::[property]
          -> (gadget[property] arguments...) for gadget in gadgets
        else
          [first] = gadgets
          first?[property]

      set: (target, property, value) ->
        {gadgets} = target
        (gadget[property] = value) for gadget in gadgets
        true

  @select: (selector) ->
    results = []
    for element in (document.querySelectorAll selector)
      try
        tag = element.tagName.toLowerCase()
        await customElements.whenDefined tag
        results.push element.gadget if element.gadget?
    new @Collection results

  @properties: (descriptors) ->
    for name, descriptor of descriptors
      descriptor.enumerable ?= true
      Object.defineProperty @::, name, descriptor

  @properties
    shadow:
      get: -> @dom.shadowRoot
    html:
      get: -> @shadow.innerHTML
      set: (value) -> innerHTML @shadow, value

  @events: (descriptors) ->
    @::__addEventListeners = ->
      for selector, events of descriptors
        _filter = (handler) ->
          if selector == "host"
            (event) -> handler event
          else
            (event) ->
              {target} = event
              (handler event) if target.matches selector
        for name, handler of events
          _handler = _filter handler.bind @
          @shadow.addEventListener name, _handler, true

  __importStyles: ->
    @benchmark "import styles", =>
      re = ///#{@name}\s+:host\s+///g
      @sheet =
        for sheet in document.styleSheets when sheet.rules?
          (for rule in sheet.rules when (rule.cssText.match re)
            rule.cssText.replace re, "").join "\n"

  @loading: loading

export {Gadget}
