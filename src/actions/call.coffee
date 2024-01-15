import { arity, flow } from "@dashkite/joy/function"
import { poke, read } from "@dashkite/katana"

_call = ( f ) ->
  arity ( f.length + 1 ), 
    ( handle, ax... ) ->
      f.apply handle, ax

call = ( f ) -> flow [
  read "handle"
  poke _call f
]

export { call }
