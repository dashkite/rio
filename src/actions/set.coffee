import {curry, pipe} from "@pandastrike/garden"
import {spush, read} from "@dashkite/katana"

_set = curry (name, handle, value) -> handle[name]  = value

set = (name) ->
  pipe [
    read "handle"
    spush _set name
  ]

set._ = _set

export {set}
