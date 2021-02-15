import {curry, pipe} from "@pandastrike/garden"
import {spoke, read} from "@dashkite/katana"

_set = curry (name, handle, value) -> handle[name]  = value

set = (name) ->
  pipe [
    read "handle"
    spoke _set name
  ]

set._ = _set

export {set}
