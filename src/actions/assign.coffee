import {curry} from "@pandastrike/garden"
import {pop} from "@dashkite/katana"

assign = curry (name) ->
  pop (value, handle) -> Object.assign handle[name], value

export {assign}
