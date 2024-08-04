import { curry, pipe, rtee } from "@dashkite/joy/function"
import { read } from "@dashkite/katana/sync"

initialize = curry rtee ( fx, Type ) ->

  Type::initialize ?= ->
    for handler in Type.initializers
      handler handle: @
    @dispatch "ready"

  Type.initializers ?= []

  Type.initializers.push pipe [
    read "handle"
    fx...
  ]

export { initialize }
