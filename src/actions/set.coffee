import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

set = ( name ) ->
  Fn.pipe [
    K.read "handle"
    K.peek ( handle, value ) -> handle[ name ] = value
  ]

export { set }
