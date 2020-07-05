import {curry, flow} from "@pandastrike/garden"
import {push, read} from "@dashkite/katana"

_get = curry (name, handle) -> handle[name]

get = (name) ->
  flow [
    read "handle"
    push _get name
  ]

get._ = _get

export {get}
