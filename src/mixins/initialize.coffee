import { curry, pipe, rtee } from "@dashkite/joy/function"
import { read } from "@dashkite/katana/sync"

initialize = curry rtee ( fx, type ) ->
  f = pipe [
    read "handle"
    fx...
  ]
  type::initialize = ->
    f handle: @
    @dispatch "ready"

export { initialize }
