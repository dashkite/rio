import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, promise, follow,
  isObject, isKind, isArray,
  properties as $P, methods as $M} from "fairmont-helpers"
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

evented = pipe [
  tee (type) -> type::isReady = true
  $methods
    on: (description) -> (@events ?= []).push description
    ready: (f) ->
      @on
        host:
          initialize:
            # initialize event can only be fired once
            # but we go ahead and set once here as well
            # so the event handler isn't hanging around
            once: true
            handler: ->
              @isReady = promise (resolve) =>
                await f.call @
                resolve true

  methods
    on: (description) -> events @, description
    dispatch: (name) ->
      @dom.dispatchEvent new CustomEvent name,
        detail: @
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true
    connect: ->
      # the first time we fire the connect event
      # we'll also fire the initialize event, but
      # only the first time ...
      @on
        host:
          connect:
            once: true
            handler: -> @dispatch "initialize"
      @on @constructor.events if @constructor.events?
      @dispatch "connect"
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
      tag: get -> name
      Component: get -> E

    $P type::, tag: get: -> @constructor.tag

    # allow the gadget to be fully defined
    # before registering it...otw the connect
    # callback may fire before we've set up
    # initialization handlers
    requestAnimationFrame ->
      customElements.define type.tag, type.Component, extends: _extends

Method.define tag, isString, (name) -> tag {name}

shadow = tee (type) ->
  type.ready -> @dom.attachShadow mode: "open"
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
      @on host: change: -> target.value = @value

vdom = properties
  html:
    get: -> @_html
    set: (html) ->
      @_html = innerHTML @root, html
      .then => @root.innerHTML
      @dispatch "render"
      @_html

autorender = tee (type) ->
  type.on host: change: -> @render()
  type.ready -> @render()

template = method render: -> @html = await @constructor.template @
ragtime = pipe [ evented, root, vdom, template ]
swing = pipe [ ragtime, autorender ]
bebop = pipe [ swing, reactor ]

# adapt mixins for use dynamically
# make this accessible so new mixins can add helpers
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
  once: (type, handler) -> type.once handler
  ready: (type, handler) -> type.ready handler

isDerived = (t) -> (x) -> isKind t, x::

gadget = Method.create default: -> throw new TypeError "gadget: bad arguments"

Method.define gadget, (isDerived Gadget), isObject, (type, description) ->
  for key, value of description
    if helpers[key]?
      helpers[key] type, value
    else
      type[key] = value

Method.define gadget, isObject, (description) ->
  gadget (Gadget.define()), description

do (tag=undefined) ->
  Method.define gadget, (isKind HTMLElement), (element) ->
    tag = element.tagName.toLowerCase()
    await customElements.whenDefined tag
    await element.gadget.isReady
    element.gadget


export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  evented,
  accessors, tag, shadow,
  reactor,
  vdom, autorender, template,
  # presets
  ragtime, swing, bebop,
  # create or obtain gadget
  gadget}
