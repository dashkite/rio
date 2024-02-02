import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

assign = ( name ) ->
  Fn.pipe [
    K.read "handle"
    K.peek ( handle, value ) -> 
      handle[ name ] ?= {}
      Object.assign handle[ name ], value
  ]

export { assign }
