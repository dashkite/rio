import { poke } from "@dashkite/katana"

get = ( name ) ->
  poke ( object ) -> object[ name ]

export { get }
