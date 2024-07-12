import * as K from "@dashkite/katana/sync"

closest = ( selector ) ->
  K.poke ( target ) -> target.closest selector

export { closest }