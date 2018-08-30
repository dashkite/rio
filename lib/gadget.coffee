import {apply, spread, pipe as _pipe} from "fairmont-core"
import {Method} from "fairmont-multimethods"
import {isObject, isKind, isArray} from "fairmont-helpers"
import {property, properties, method, methods, assign,
  evented,
  accessors, tag,
  decorate,
  } from "./mixins"

pipe = spread _pipe

class Gadget

  @define: -> apply (pipe [evented, accessors]), (class extends Gadget)

  constructor: (@dom) ->

  # initialize is idempotent
  connect: -> @initialize()
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
  decorate: helper decorate
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

export {gadget, Gadget}
