import HTML from "./vhtml.js"
{style, parse} = HTML

# TODO: import from Fairmont Helpers
isType = (t, x) -> x? && (Object.getPrototypeOf x) == t::
isString = (x) -> isType String, x
isFunction = (x) -> isType Function, x
isObject = (x) -> isType Object, x

innerHTML = null
loading = do ->
  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]
  true

class Gadget

  constructor: (@dom) ->

  connect: -> @initialize()

  initialize: ->
    @initialize = ->
    @benchmark "initialization", =>
      @events()
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

  # TODO: use multimethod here?
  on: (descriptors) ->
    for key, value of descriptors
      if isFunction value
        @shadow.addEventListener key, value
      else if isObject value
        for name, handler of value
          @shadow.addEventListener name, do (handler) =>
            if key == "host"
              (event) => (handler event) if event.target == @shadow
            else
              (event) => (handler event) if event.target.matches key

  dispatch: (name) ->
    @log "dispatch '#{name}'"
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

  events: ->
    @on host: change: (event) =>
      @render()
      event.stopPropagation()

  log: -> @constructor.log arguments...
  @log: (description) -> console.log "[ #{@tag} ] #{description}"

  benchmark: -> @constructor.benchmark arguments...
  @benchmark: (description, f) ->
    start = performance.now()
    f()
    end = performance.now()
    @log "#{description}: #{end - start}ms"

  @register: (@tag) ->
    self = @
    self.Component = class extends HTMLElement
      constructor: ->
        super()
        @attachShadow mode: "open"
        @gadget = new self @
      connectedCallback: -> @gadget.connect()
    requestAnimationFrame ->
      customElements.define self.tag, self.Component

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
    tag:
      get: -> @constructor.tag
    shadow:
      get: -> @dom.shadowRoot
    html:
      get: -> @shadow.innerHTML
      set: (value) -> innerHTML @shadow, value
    value:
      do (_value=undefined) ->
        get: -> _value
        set: (value) ->
          _value = value
          @dispatch "change"
          value

  __importStyles: ->
    @benchmark "import styles", =>
      re = ///#{@tag}\s+:host\s+///g
      @sheet =
        for sheet in document.styleSheets when sheet.rules?
          (for rule in sheet.rules when (rule.cssText.match re)
            rule.cssText.replace re, "").join "\n"

  @loading: loading

export {Gadget}
