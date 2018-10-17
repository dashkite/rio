import {isString, isObject, isArray, isFunction, isKind} from "panda-parchment"
import {Method} from "panda-generics"

# implementation helpers

normalize = (options = {}) ->
  {bubble, once, predicate} = Object.assign
      predicate: -> true
      once: false
      bubble: true
    ,
      options
  {bubble, once, predicate}

listen = (gadget, name, options, handler) ->
  {predicate, once, bubble} = normalize options
  _handler = (event) ->
    event.stopPropagation() unless bubble
    if predicate event
      handler.call gadget, event
      (mute gadget, name, _handler) if once
  gadget.root.addEventListener name, _handler

mute = (gadget, name, handler) ->
  gadget.root.removeEventListener name, handler

# event generic

class EventDescriptorError extends Error
  constructor: (@descriptor, args...) ->
    super "gadget: bad event descriptor", args...
    if Error.captureStackTrace?
      Error.captureStackTrace @, EventDescriptorError

events = Method.create default: (args...)->
  throw new EventDescriptorError args

# simple event handler with no selector
Method.define events, (isKind Object), isString, isObject, isFunction,
  (gadget, name, options, handler) ->
    listen gadget, name, options, handler

# event handler using a selector, event name, and handler
Method.define events,
  (isKind Object), isString, isString, isObject, isFunction,
    (gadget, selector, name, options, handler) ->
      options.predicate = (event) ->
        ((event.target.matches selector) ||
          (options.bubble && ((event.target.closest selector)?)))
      listen gadget, name, options, handler

# selector + event handler defined as part of options
Method.define events,
  (isKind Object), isString, isString, isObject,
    (gadget, selector, name, options) ->
      {handler} = options
      events gadget, selector, name, options, handler

# selector + event handler defined directly
Method.define events,
  (isKind Object), isString, isString, isFunction,
    (gadget, selector, name, handler) ->
      events gadget, selector, name, {}, handler

# event handler defined directly
# TODO: make it possible to pass options for this case?
# (currently, ambiguous with next generic, but could distinguish
# based on property names?)
Method.define events,
  (isKind Object), isString, isFunction, (gadget, name, handler) ->
    events gadget, name, {}, handler

# a dictionary of event handlers for a selector
Method.define events, (isKind Object), isString, isObject,
  (gadget, selector, description) ->
    (events gadget, selector, name, handler) for name, handler of description

# a dictionary of event handlers
Method.define events, (isKind Object), isObject,
  (gadget, description) ->
    (events gadget, key, value) for key, value of description

# an array of dictionaries
Method.define events, (isKind Object), isArray, (gadget, descriptions) ->
  (events gadget, description) for description in descriptions

export {events}
