import { read } from "@dashkite/katana/sync"
import { curry, pipe, rtee } from "@dashkite/joy/function"

connect = curry rtee ( fx, Type ) ->

  Type.onConnect ?= []

  Type.onConnect.push pipe [
    read "handle"
    fx...
  ]

  Type::connect ?= ->
    for handler in Type.onConnect
      handler handle: @

export { connect }
