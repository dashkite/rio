import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

_matches = ( selector ) ->
  ( event ) -> event.target.matches? selector

matches = ( selector, fx ) -> 
  K.test ( _matches selector ), Fn.pipe fx

export { matches }
