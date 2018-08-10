import {isString, isObject, isArray, isKind, isFunction,
  properties as $P, methods as $M} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"

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
      if (event.target.matches selector) || (event.target.closest selector)?
        handler.call gadget, event

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

export {events}
