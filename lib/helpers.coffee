isGadgetClass = (x) ->
  x == Gadget || (isTransitivePrototype Gadget, x)

gadget = Method.create default: -> throw new TypeError "gadget: bad arguments"

Method.define gadget, isGadgetClass, isObject, (base, description) ->
  (base[key]? value) for key, value of description

Method.define gadget, isObject, (description) ->
  gadget (class extends Gadget), description

export {gadget}
