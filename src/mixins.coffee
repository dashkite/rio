import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {w, bind,
  isString, isObject, isKind, isArray,
  promise, follow,
  properties as $P, methods as $M} from "panda-parchment"
import {Method} from "panda-generics"
import {apply, spread, pipe as _pipe, tee} from "panda-garden"
import {go, map, into, wait} from "panda-river-esm"
import {events} from "./events"
import {Gadget} from "./gadget"

pipe = spread _pipe

property = properties = (description) -> tee (type) -> $P type::, description
$property = $properties = (description) -> tee (type) -> $P type, description
method = methods = (description) -> tee (type) -> $M type::, description
$method = $methods = (description) -> tee (type) -> $M type, description
assign = (description) -> tee (type) -> Object.assign type::, description
$assign = (description) -> tee (type) -> Object.assign type, description

phased = pipe [

  $methods
    connect: (f) -> (@_connect ?= []).push f
    prepare: (f) -> (@_prepare ?= []).push f
    ready: (f) -> (@_ready ?= []).push f

  methods
    connect: ->
      @ready = promise (resolve) =>
        await go [
          w "connect prepare ready"
          map (phase) => @constructor["_#{phase}"]
          # map into [
          #   map bind @
          #   map apply
          # ]
          map (handlers) =>
            if handlers?
              for handler in handlers
                apply bind handler, @
            else
              []
          wait map (promises) -> Promise.all promises
        ]
        resolve true
]

evented = pipe [

  $methods
    on: (description) -> (@events ?= []).push description

  methods
    on: (args...) -> events @, args...
    dispatch: (name) ->
      @root.dispatchEvent new CustomEvent name,
        detail: @
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true

  tee (type) ->
    type.ready -> @on @constructor.events if @constructor.events?

]

root = property root: get: -> if @shadow? then @shadow else @dom

html = property
  get: -> @root.innerHTML
  set: (value) -> @root.innerHTML = value

tag = Method.create()

Method.define tag, isObject, (options) ->

  {name} = options
  _extends = options.extends

  tee (type) ->

    E = class extends HTMLElement
      constructor: ->
        super()
        @gadget = new type @
      connectedCallback: -> @gadget.connect()

    $P type,
      tag: get: -> name
      Component: get: -> E

    $P type::, tag: get: -> @constructor.tag

    requestAnimationFrame ->
      customElements.define type.tag, type.Component, extends: _extends

Method.define tag, isString, (name) -> tag {name}

shadow = tee (type) ->
  type.prepare -> @dom.attachShadow mode: "open"
  $P type::, shadow: get: -> @dom.shadowRoot

reactor = tee (type) ->
  $P type::,
    value:
      get: -> @_value
      set: (value) ->
        @_value = follow value
        @dispatch "change"
        @_value

  $M type::,
    pipe: (target) ->
      @on change: -> target.value = @value

vdom = properties
  html:
    # follow if not set to ensure interface
    # is consistent
    get: -> @_html ?= follow @root.innerHTML
    set: (html) ->
      @_html = innerHTML @root, html
      .then => @root.innerHTML

template = method
  render: ->
    @html = await @constructor.template @
    @dispatch "render"

autorender = tee (type) ->
  type.on change: -> @render()
  type.ready -> @render()


ragtime = pipe [ phased, root, evented, vdom, template ]
swing = pipe [ ragtime, reactor ]
bebop = pipe [ swing, autorender ]

# adapt mixins for use dynamically
helper = (mixin) -> (type, value) -> ((mixin value) type)
helpers =
  tag: helper tag
  mixins: (type, handler) ->
    handler = pipe handler if isArray handler
    handler type
  instance: helper assign
  property: helper property
  properties: helper properties
  method: helper method
  methods: helper methods
  on: (type, handler) -> type.on handler
  ready: (type, handler) -> type.ready handler

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  phased, root, evented,
  accessors, tag, shadow,
  reactor,
  vdom, autorender, template,
  # presets
  ragtime, swing, bebop,
  helper, helpers}
