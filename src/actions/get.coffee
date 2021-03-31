import {curry, flow} from "@dashkite/joy/function"
import {poke, read} from "@dashkite/katana"

_get = curry (name, handle) -> handle[name]

get = (name) ->
  flow [
    read "handle"
    poke _get name
  ]

get._ = _get

export {get}
