import {HTML} from "./vhtml"
{style, parse} = HTML

import {innerHTML} from "diffhtml"

import {prototype, isKind, isTransitivePrototype,
  isString, isFunction, isAsyncFunction, isObject,
  properties} from "fairmont-helpers"

import {Method} from "fairmont-multimethods"

base = (x) -> prototype x.constructor

class Gadget

  constructor: (@dom) ->

  properties @::,
    super:
      get: -> (prototype prototype @)
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

  @properties: (description) -> properties @::, description

  connect: ->
    await @initialize()
    @ready()

  initialize: ->
    @initialize = ->
    @events()

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

  # defined using multimethods, see below
  on: (description) -> _on @, description

  dispatch: (name) ->
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

  events: ->
    @on host: change: (event) =>
      @render()
      event.stopPropagation()

  @events: (description) ->
    @::events = ->
      # can't use super here b/c JS doesn't allow it
      # outside of method definitions
      (base @)::events.call @
      @on description
    @

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
    @

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
    @

  @Collection: class
    constructor: (@gadgets) -> return new Proxy @,
      get: (target, property) ->
        {gadgets} = target
        if isFunction Gadget::[property]
          -> (gadget[property] arguments...) for gadget in gadgets
        else if isAsyncFunction Gadget::[property]
          -> Promise.all ((gadget[property] arguments...) for gadget in gadgets)
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

  @pipe: (gadgets...) ->
    # TODO: use Fairmont Reactor
    gadgets.reduce (source, target) ->
      source.on change: -> target.value = source.value
      target

  @ready: (f) ->
    document.addEventListener "DOMContentLoaded", f
    @

# Selector-based event handling

isGadget = isKind Gadget
isHostSelector = (s) -> s == "host"

_on = Method.create default: -> # ignore bad descriptions

# simple event handler with no selector
Method.define _on, isGadget, isString, isFunction,
  (gadget, name, handler) ->
    gadget.shadow.addEventListener name, handler.bind gadget

# event handler using a selector, event name, and handler
Method.define _on, isGadget, isString, isString, isFunction,
  (gadget, selector, name, handler) ->
    gadget.shadow.addEventListener name, (event) ->
      (handler.call gadget, event) if (event.target.matches selector)

# event handler using special host selector (that's the shadow root)
# must be defined after generic selector otw this never gets called
Method.define _on, isGadget, isHostSelector, isString, isFunction,
  (gadget, selector, name, handler) ->
    gadget.shadow.addEventListener name, (event) ->
      (handler.call gadget, event) if (event.target == gadget.shadow)

# a dictionary of event handlers for a selector
Method.define _on, isGadget, isString, isObject,
  (gadget, selector, description) ->
    (_on gadget, selector, name, handler) for name, handler of description

# a dictionary of event handlers of some kind—our starting point
Method.define _on, isGadget, isObject,
  (gadget, description) ->
    (_on gadget, key, value) for key, value of description

isGadgetClass = (x) ->
  x == Gadget || (isTransitivePrototype Gadget, x)

# gadget creation function if you want less clutter
gadget = Method.create default: -> throw new TypeError "gadget: bad arguments"

Method.define gadget, isGadgetClass, isObject, (base, description) ->
  description.ready ?= ->
  class extends base
    template: description.template
    ready: ->
      super.ready()
      description.ready.call @
    @register description.name
    @events description.events if description.events?
    @observe description.observe if description.observe?
    @properties description.properties if description.properties?

Method.define gadget, isObject, (description) ->
  gadget Gadget, description

export {gadget, Gadget}
