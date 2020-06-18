import {curry, flow} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

_assign = curry (name, handle, value) ->
  Object.assign handle[name], value

assign = (name) -> flow [
  read "handle"
  pop _assign name
]

export {assign, _assign}
