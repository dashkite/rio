import {Method} from "fairmont-multimethods"
import {isObject, isKind} from "fairmont-helpers"
import {mix, domEvented, componentAccessors,
  tag, instance, observe, property, properties} from "./mixins"

class Gadget

  @define: ->
    mix (class extends Gadget),
      [ domEvented, componentAccessors ]

  constructor: (@dom) ->

  # initialize is idempotent
  connect: -> @initialize()
# adapt mixins for use dynamically
helper = (mixin) -> (type, value) -> ((mixin value) type)
helpers =
  tag: helper tag
  mixins: mix
  instance: helper instance
  property: helper property
  properties: helper properties
  observe: helper observe
  on: (type, handler) -> type.on handler
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

Method.define gadget, (isKind HTMLElement), do (tag=undefined) -> (element) ->
  tag = element.tagName.toLowerCase()
  await customElements.whenDefined tag
  element.gadget

export {gadget, Gadget}
