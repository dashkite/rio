import {curry, pipe} from "@dashkite/joy/function"
import {poke, read} from "@dashkite/katana/sync"

_set = curry (name, handle, value) -> handle[name]  = value

set = (name) ->
  pipe [
    read "handle"
    poke _set name
  ]

set._ = _set

export {set}
