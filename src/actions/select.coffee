import * as K from "@dashkite/katana/sync"

select = ( selector ) ->
  K.poke ( el ) -> el.querySelector selector

export { select }