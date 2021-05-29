import {curry, pipe} from "@dashkite/joy/function"
import {poke, read} from "@dashkite/katana/sync"

_assign = curry (name, handle, value) ->
  handle[name] ?= {}
  Object.assign handle[name], value

assign = (name) -> pipe [
  read "handle"
  poke _assign name
]

assign._ = _assign

export {assign}
