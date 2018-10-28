import {properties as $P, methods as $M} from "panda-parchment"
import {tee} from "panda-garden"

$property = $properties = (description) -> tee (type) -> $P type, description
property = properties = (description) -> tee (type) -> $P type::, description

$method = $methods = (description) -> tee (type) -> $M type, description
method = methods = (description) -> tee (type) -> $M type::, description

$assign = (description) -> tee (type) -> Object.assign type, description
assign = (description) -> tee (type) -> Object.assign type::, description

mixin = (type, mixins) -> _mixin type for _mixin in mixins

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign, mixin}
