import {curry, pipe} from "@pandastrike/garden"
import {spoke, read} from "@dashkite/katana"

_assign = curry (name, handle, value) ->
  handle[name] ?= {}
  Object.assign handle[name], value

assign = (name) -> pipe [
  read "handle"
  spoke _assign name
]

assign._ = _assign

export {assign}
