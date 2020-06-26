import {curry, flow} from "@pandastrike/garden"
import {poke, read} from "@dashkite/katana"

_assign = curry (name, handle, value) ->
  handle[name] ?= {}
  Object.assign handle[name], value

assign = (name) -> flow [
  read "handle"
  poke _assign name
]

assign._ = _assign

export {assign}
