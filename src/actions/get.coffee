import {curry, flow} from "@pandastrike/garden"
import {poke, read} from "@dashkite/katana"

_get = curry (name, handle) -> handle[name]

get = (name) ->
  flow [
    read "handle"
    poke _get name
  ]

get._ = _get

export {get}
