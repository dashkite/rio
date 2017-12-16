import {
  isObject, isKind, isFunction, isTransitivePrototype
} from "fairmont-helpers"

import {Method} from "fairmont-multimethods"
import {Gadget} from "./gadget"

isGadgetClass = (x) ->
  x == Gadget || (isTransitivePrototype Gadget, x)

gadget = Method.create default: -> throw new TypeError "gadget: bad arguments"

Method.define gadget, isGadgetClass, isObject, (base, description) ->
  for key, value of description
    if isFunction base[key]
      base[key] value
    else
      base[key] = value

Method.define gadget, isObject, (description) ->
  gadget (class extends Gadget), description

Method.define gadget, (isKind HTMLElement), (element) ->
  tag = element.tagName.toLowerCase()
  await customElements.whenDefined tag
  element.gadget


export {gadget}
