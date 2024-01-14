import { poke } from "@dashkite/katana/sync"

attribute = ( name ) ->
  poke ( el ) -> el.getAttribute name

export { attribute }
