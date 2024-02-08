import { curry, pipe, rtee } from "@dashkite/joy/function"

connect = curry rtee ( fx, type ) ->
  f = pipe fx
  type::connect = ->
    f [ @ ], handle: @
    @dispatch "ready"

export { connect }
