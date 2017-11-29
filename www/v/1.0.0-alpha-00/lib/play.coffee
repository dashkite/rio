import HTML from "./vhtml.js"
{style, parse} = HTML

# TODO: import from Fairmont Helpers
prototype = (x) -> Object.getPrototypeOf x
isType = (t, x) -> x? && (prototype x) == t::
isString = (x) -> isType String, x
isFunction = (x) -> isType Function, x
isObject = (x) -> isType Object, x
base = (x) -> prototype x.constructor
properties = (self, descriptors) ->
  for name, descriptor of descriptors
    descriptor.enumerable ?= true
    Object.defineProperty self, name, descriptor

innerHTML = null
loading = do ->
  [{innerHTML}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]
  true

class Gadget

  @loading: loading

  constructor: (@dom) ->

  properties @::,
    tag:
      get: -> @constructor.tag
    shadow:
      get: -> @dom.shadowRoot
    html:
      get: -> @shadow.innerHTML
      set: (value) -> innerHTML @shadow, value
    styles:
      get: ->
        styles = ""
        re = ///#{@tag}\s+:host\s+///g
        for sheet in document.styleSheets when sheet.rules?
          for rule in sheet.rules when (rule.cssText.match re)
            styles += (rule.cssText.replace re, "") + "\n"
        styles

  connect: -> @initialize()

  initialize: ->
    @initialize = ->
    await Gadget.loading
    @events()
    @ready()

  ready: -> @render()

  render: ->
    if @template?
      html = @template @
      # convert to vdom if necessary...
      html = parse html if isString html
      # ...so we can add imported styles
      html.push style @styles
      # remember, this diffs and patches
      @html = html
    else
      @html = ""

  # TODO: use multimethod here?
  on: (descriptors) ->
    for key, value of descriptors
      if isFunction value
        @shadow.addEventListener key, (value.bind @)
      else if isObject value
        for name, handler of value
          @shadow.addEventListener name, do (handler=(handler.bind @)) =>
            if key == "host"
              (event) => (handler event) if event.target == @shadow
            else
              (event) => (handler event) if event.target.matches key

  dispatch: (name) ->
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

  bind: (gadget) ->
    @on change: -> gadget.value = @value

  events: ->
    @on host: change: (event) =>
      @render()
      event.stopPropagation()

  @events: (descriptors) ->
    @::events = ->
      # can't use super here b/c JS doesn't allow it
      # outside of method definitions
      (base @)::events.call @
      @on descriptors

  @observe: (descriptors) ->
    for key, value of descriptors
      properties @::,
        "#{key}":
          do (value) ->
            get: -> value
            set: (_value) ->
              value = _value
              @dispatch "change"
              value

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

export {Gadget}
