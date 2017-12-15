# Selector-based event handling
import {isKind, isString, isArray, isFunction} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"

isGadget = isKind Gadget
isHostSelector = (s) -> s == "host"

events = Method.create default: -> # ignore bad descriptions

# simple event handler with no selector
Method.define events, isGadget, isString, isFunction,
  (gadget, name, handler) ->
    gadget.shadow.addEventListener name, handler.bind gadget

# event handler using a selector, event name, and handler
Method.define events, isGadget, isString, isString, isFunction,
  (gadget, selector, name, handler) ->
    gadget.shadow.addEventListener name, (event) ->
      (handler.call gadget, event) if (event.target.matches selector)

# event handler using special host selector (that's the shadow root)
# must be defined after generic selector otw this never gets called
Method.define events, isGadget, isHostSelector, isString, isFunction,
  (gadget, selector, name, handler) ->
    gadget.shadow.addEventListener name, (event) ->
      (handler.call gadget, event) if (event.target == gadget.shadow)

# a dictionary of event handlers for a selector
Method.define events, isGadget, isString, isObject,
  (gadget, selector, description) ->
    (events gadget, selector, name, handler) for name, handler of description

# a dictionary of event handlers of some kind—our starting point
Method.define events, isGadget, isObject,
  (gadget, description) ->
    (events gadget, key, value) for key, value of description

# an array of dictionaries
Method.define events, isGadget, isArray (gadget, descriptions) ->
  (events gadget, description) for description in descriptions

# read from events property of a gadget
Method.define events, isGadget, (gadget) ->
  events gadget, gadget.constructor.events

export {events}
