import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, isObject, isArray, isKind, isFunction,
  properties as _properties} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"

Type =
  create: (type) -> if type? then new type
  define: (parent = Object) -> class extends parent

mix = Method.create default: -> new TypeError "mixins: bad argument"

Method.define mix, (isKind Object), isFunction, (type, mixin) -> mixin type

Method.define mix, (isKind Object), isArray, (type, list) ->
  list.reduce ((type, mixin) -> mix type, mixin), type

# adapts a function to always return its first argument
tee = (f) -> (first, rest...) -> (f first, rest...); first
# call f with value and return value
given = (value, f) -> (f value) ; value

properties = (description) ->
  tee (type) -> _properties type::, description

property = (key, value) -> properties [key]: value

observe = (description, handler) ->
  for key, value of description
    property key, do (value) ->
      get: -> value
      set: (x) ->
        value = x
        handler.call @, value

composable = [
  observe value: "", -> @dispatch "change"
  tee (source) ->
    source::pipe = (target) ->
      @on change: -> target.value = @value
]

evented = (implementation) ->
  tee (type) ->
    Object.assign type,
      on: (description) -> (@events ?= []).push description
    Object.assign type::, implementation

domEvented = tee (type) ->
  Object.assign type,
    on: (description) -> (@events ?= []).push description
    ready: (f) ->
      g = (event) ->
        event.target.removeEventListener event.type, g
        f.call @, event
      @on initialize: g

  Object.assign type::,

    on: do (events=null) ->

      events = Method.create default: ->
        console.log "arguments": arguments
        throw new Error "gadget: bad event descriptor"

      # simple event handler with no selector
      Method.define events, (isKind Object), isString, isFunction,
        (gadget, name, handler) ->
          gadget.shadow.addEventListener name, handler.bind gadget

      # event handler using a selector, event name, and handler
      Method.define events, (isKind Object), isString, isString, isFunction,
        (gadget, selector, name, handler) ->
          gadget.shadow.addEventListener name, (event) ->
            (handler.call gadget, event) if (event.target.matches selector)

      # event handler using special host selector (that's the shadow root)
      # must be defined after generic selector otw this never gets called
      Method.define events,
        (isKind Object), ((s) -> s == "host"), isString, isFunction,
          (gadget, selector, name, handler) ->
            gadget.shadow.addEventListener name, (event) ->
              (handler.call gadget, event) if (event.target == gadget.shadow)

      # a dictionary of event handlers for a selector
      Method.define events, (isKind Object), isString, isObject,
        (gadget, selector, description) ->
          (events gadget, selector, name, handler) for name, handler of description

      # a dictionary of event handlers of some kind—our starting point
      Method.define events, (isKind Object), isObject,
        (gadget, description) ->
          (events gadget, key, value) for key, value of description

      # an array of dictionaries
      Method.define events, (isKind Object), isArray, (gadget, descriptions) ->
        (events gadget, description) for description in descriptions

      (description) -> events @, description

    dispatch: (name, {local} = {local: false}) ->
      @shadow.dispatchEvent new Event name,
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: !local

    initialize: ->
      @initialize = ->
      @on @constructor.events
      @dispatch "initialize", local: true

vdom = properties
  html:
    get: -> @shadow.innerHTML
    set: do ({style, parse} = HTML) ->
      (html) ->
        vdom = if (isString html) then (parse html) else html
        vdom.push (style @styles)
        innerHTML @shadow, vdom

autorender = tee (type) ->
  type.on change: -> @render()
  type::ready = -> @render()

template = tee (type) ->
  type::render = -> @html = @constructor.template @

styles = properties
  styles:
    get: ->
      styles = ""
      re = ///#{@tag}\s+:host\s+///g
      for sheet in document.styleSheets when sheet.rules?
        for rule in sheet.rules when (rule.cssText.match re)
          styles += (rule.cssText.replace re, "") + "\n"
      styles

componentAccessors = properties
  tag:
    get: -> @constructor.tag
  shadow:
    get: -> @dom.shadowRoot
  html:
    get: -> @shadow.innerHTML
    set: (value) -> @shadow.innerHTML = value

tag = (name) ->
  tee (type) ->
    type.tag = name
    type.Component = class extends HTMLElement
      constructor: ->
        super()
        @gadget = new type @
        @attachShadow mode: "open"
      connectedCallback: -> @gadget.connect()
    # allow the gadget to be fully defined
    # before registering it...
    requestAnimationFrame ->
      customElements.define type.tag, type.Component

instance = (description) ->
  tee (type) -> Object.assign type::, description

calypso = [ vdom, styles, template ]
zen = [ calypso, composable, autorender ]

export {property, properties, observe, composable,
  evented, domEvented,
  vdom, autorender, template, styles,
  tag, componentAccessors, instance,
  # presets
  calypso, zen,
  # application
  mix}
