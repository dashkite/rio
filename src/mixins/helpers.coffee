import {properties as $P, methods as $M} from "panda-parchment"
import {curry, tee, rtee, spread, pipe as _pipe} from "panda-garden"

$property = $properties = (description) -> tee (type) -> $P type, description
property = properties = (description) -> tee (type) -> $P type::, description

getter = curry rtee (description, type) ->
  for key, value of description
    $P type::, [key]: get: value

$method = $methods = (description) -> tee (type) -> $M type, description
method = methods = (description) -> tee (type) -> $M type::, description

$assign = (description) -> tee (type) -> Object.assign type, description
assign = (description) -> tee (type) -> Object.assign type::, description

mixin = (type, mixins) -> _mixin type for _mixin in mixins

pipe = spread _pipe

export {property, properties, $property, $properties, getter,
  method, methods, $method, $methods, assign, $assign, mixin, pipe}
