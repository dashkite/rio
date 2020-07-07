import {curry, flow} from "@pandastrike/garden"
import {push, read} from "@dashkite/katana"

_set = curry (name, handle, value) -> handle[name]  = value

get = (name) ->
  flow [
    read "handle"
    push _set name
  ]

set._ = _set

export {set}
