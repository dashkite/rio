import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, properties as $P, methods as $M} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"
import {spread, pipe as _pipe, tee, apply} from "fairmont-core"
import {events} from "./events"
import {queue} from "./river/queue"
import {mutex} from "./river/mutex"

pipe = spread _pipe

property = properties = (description) -> tee (type) -> $P type::, description
$property = $properties = (description) -> tee (type) -> $P type, description
method = methods = (description) -> tee (type) -> $M type::, description
$method = $methods = (description) -> tee (type) -> $M type, description
assign = (description) -> tee (type) -> Object.assign type::, description
$assign = (description) -> tee (type) -> Object.assign type, description

decorate = (decorator) ->
  tee (type) -> type::decorate = decorator

observe = (description, handler) ->
  pipe do ->
    for key, {initialize, handler, decorator} of description
      pipe do (key, initialize, handler, decorator) ->
        _key = "_#{key}"
        [
          property [key]:
            get: -> @[_key] ?= initialize.call @
            set: (value) ->
              @[_key] = decorator.call @, value
              handler.call @
              @value
        ]

evented = pipe [
  $methods
    on: (description) -> (@events ?= []).push description
    # TODO: add support for once
    ready: (f) ->
      @::isReady = new Promise (resolve) =>
        @on host:
          initialize: ->
            # TODO: I thought we didn't need this wrapper for async handlers
            do =>
              await f.call @
              resolve()

  methods
    on: (description) -> events @, description
    dispatch: (name) ->
      @dom.dispatchEvent new CustomEvent name,
        detail: @
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true
    initialize: ->
      @initialize = ->
      @on @constructor.events if @constructor.events?
      @dispatch "initialize"
    when: (name) ->
      new Promise (resolve) =>
        @on host:
          [name]:
            once: true
            handler: resolve
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
    property updates: get: -> @_updates ?= queue()
    observe value:
      initialize: -> undefined,
      handler: (value) -> @updates.enqueue value
      decorator: (value) ->
        if @decorator?
          @decorator value
        else value
    method pipe: (target) ->
      for await value from @updates
        target.value = await value
  ]

vdom = properties
  html:
    get: -> @shadow.innerHTML
    set: do ({parse} = HTML) ->
      (html) ->
        vdom = if (isString html) then (parse html) else html
        innerHTML @shadow, vdom
        .then => @dispatch "render"

autorender = tee (type) ->
  type.on host: change: -> @render()
  type.on host: initialize: -> @render()

template = method render: -> @html = @constructor.template @

ragtime = pipe [ vdom, template ]
swing = pipe [ ragtime, autorender ]
bebop = pipe [ swing, composable ]

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  decorate, observe,
  evented,
  accessors, tag,
  composable, vdom, autorender, template,
  # presets
  ragtime, swing, bebop,
  # application
  mix}
