import { curry, pipe, rtee } from "@dashkite/joy/function"

disconnect = curry rtee ( fx, type ) ->
  f = pipe fx
  type::disconnect = ->
    f handle: @
    @dispatch "ready"

export { disconnect }
