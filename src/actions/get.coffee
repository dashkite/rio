import { poke } from "@dashkite/katana"

get = (name) ->
  push ( object ) -> object[ name ]

export { get }
