import {isString, isObject, isArray, isFunction, isKind} from "panda-parchment"
import {Method} from "panda-generics"
import {pipe, spread, tee} from "panda-garden"
import {$property, $methods, methods} from "./helpers"

# simple DOM wrappers for Gadgets

listen = (gadget, name, handler) ->
  gadget.root.addEventListener name, handler.bind gadget

mute = (gadget, name, handler) ->
  gadget.root.removeEventListener name, handler.bind gadget

# handler combinators

once = (handler) ->
  _handler = (event) ->
    handler.call @, event
    mute @, name, _handler

prevent = (handler) ->
  (event) ->
    event.preventDefault()
    handler.call @, event

stop = (handler) ->
  (event) ->
    event.stopPropagation()
    handler.call @, event

intercept = (handler) -> prevent stop handler

local = (handler) ->
  (event) ->
    if event.detail == @
      handler.call @, event

matches = (selector, handler) ->
  (event) ->
    if (target = (event.target.closest? selector))?
      if @root.contains target
        handler.call @, event

# _on generic, used as the event registration
# implementation for the mixin

_on = Method.create()

# helper just makes declarations more concise
define = (terms, implementation) ->
  Method.define _on, (isKind Object), terms..., implementation

# simple event handler with no selector
define [ isString, isFunction ],
  (gadget, name, handler) ->
    listen gadget, name, handler

# event handler with selector
define [ isString, isString, isFunction ],
  (gadget, selector, name, handler) ->
    listen gadget, name, matches selector, handler

# a dictionary of event handlers for a selector
define [ isString, isObject ],
  (gadget, selector, description) ->
    for name, handler of description
      _on gadget, selector, name, handler

# a dictionary of event handlers
define [ isObject ],
  (gadget, description) ->
    for key, value of description
      _on gadget, key, value

# an array of dictionaries
define [ isArray ],
  (gadget, descriptions) ->
    for description in descriptions
      _on gadget, description

# evented mixin

evented = (spread pipe) [

  $property
    events:
      get: -> @_events ?= []

  $methods
    on: (description) -> @events.push description

  methods
    on: (args...) -> _on @, args...
    dispatch: (name) ->
      @root.dispatchEvent new CustomEvent name,
        detail: @
        bubbles: true
        cancelable: false
        # allow to bubble up from shadow DOM
        composed: true

  tee (type) ->
    type.ready ->
      @on @constructor.events

]

events = (description) -> tee (type) -> type.on description

export {evented, once, stop, prevent, intercept, local, matches, events}
