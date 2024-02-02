import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

get = ( name ) ->
  Fn.pipe [
    K.read "handle"
    K.poke ( handle ) -> handle[ name ]
  ]

export { get }
