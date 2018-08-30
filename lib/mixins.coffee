import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, promise,
  properties as $P, methods as $M} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"
import {spread, pipe as _pipe, tee, apply} from "fairmont-core"
import {events} from "./events"
import {queue} from "./river/queue"

# TODO: lock updates to value
import {mutex} from "./river/mutex"

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
            handler: ->
              @isReady = promise (resolve) =>
                await f.call @
                resolve true
            once: true

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

composable = tee (type) ->
  $P type::,
    lock: get: -> @_lock ?= mutex()
    updates: get: -> @_updates ?= queue()
    value:
      get: -> @_value
      set: (value) ->
        @lock =>
          @_value = @decorate value
          @updates.enqueue @_value
          do =>
            await @_value
            @dispatch "change"
          @_value

  $M type::,
    # default decorator is identity
    decorate: (value) -> value
    pipe: (target) ->
      for await value from @updates
        target.value = await value

decorate = (decorator) ->
  tee (type) -> type::decorate = decorator

vdom = properties
  html:
    get: -> @shadow.innerHTML
    set: do ({parse} = HTML) ->
      (html) ->
        vdom = if (isString html) then (parse html) else html
        innerHTML @shadow, vdom

autorender = tee (type) ->
  type.on host: change: -> @render()
  type.on host: initialize: -> @render()

template = method render: -> @html = @constructor.template @

ragtime = pipe [ vdom, template ]
swing = pipe [ ragtime, autorender ]
bebop = pipe [ swing, composable ]

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  evented,
  accessors, tag,
  composable, decorate,
  vdom, autorender, template,
  # presets
  ragtime, swing, bebop,
  # application
  mix}
