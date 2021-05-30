import {curry, pipe} from "@dashkite/joy/function"
import {read} from "@dashkite/katana/sync"

_initialize = curry (f, type) ->
  type::initialize = ->
    f handle: @
    @dispatch "ready"

initialize = (fx) ->
  _initialize pipe [
    read "handle"
    fx...
  ]

initialize._ = _initialize

export {initialize}
