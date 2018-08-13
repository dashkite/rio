import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, properties as $P, methods as $M} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"
import {spread, pipe as _pipe, tee, apply} from "fairmont-core"
import {events} from "./events"

pipe = spread _pipe

property = properties = (description) -> tee (type) -> $P type::, description
$property = $properties = (description) -> tee (type) -> $P type, description
method = methods = (description) -> tee (type) -> $M type::, description
$method = $methods = (description) -> tee (type) -> $M type, description
assign = (description) -> tee (type) -> Object.assign type::, description
$assign = (description) -> tee (type) -> Object.assign type, description

observe = (description, handler) ->
  (type) ->
    apply (pipe do ->
      for key, value of description
        property [key]: do (value) ->
          get: -> value
          set: (x) ->
            value = x
            handler.call @, value), type

evented = pipe [
  $methods
    on: (description) -> (@events ?= []).push description
    ready: (f) ->
      g = (event) ->
        event.target.removeEventListener event.type, g
        f.call @, event
      @on initialize: g
  methods
    on: (description) -> events @, description
    dispatch: (name, {local} = {local: false}) ->
      @shadow.dispatchEvent new Event name,
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: !local
    initialize: ->
      @initialize = ->
      @on @constructor.events if @constructor.events?
      @dispatch "initialize", local: true
]

accessors = properties
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

composable = pipe [
  observe value: undefined, -> @dispatch "change"
  method pipe: (target) -> @on change: -> target.value = @value
]

vdom = tee properties
  html:
    get: -> @shadow.innerHTML
    set: do ({style, parse} = HTML) ->
      (html) ->
        vdom = if (isString html) then (parse html) else html
        vdom.push (style @styles)
        innerHTML @shadow, vdom

autorender = tee (type) ->
  type.on change: -> @render()
  type.ready -> @render()

template = method render: -> @html = @constructor.template @

styles = property
  styles:
    get: ->
      styles = ""
      re = ///#{@tag}\s+:host\s+///g
      for sheet in document.styleSheets when sheet.rules?
        for rule in sheet.rules when (rule.cssText.match re)
          styles += (rule.cssText.replace re, "") + "\n"
      styles

calypso = pipe [ vdom, styles, template ]
zen = pipe [ calypso, composable, autorender ]

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  observe, evented, accessors, tag,
  composable, vdom, autorender, template, styles,
  # presets
  calypso, zen,
  # application
  mix}
