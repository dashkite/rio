import * as F from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

_within = ( selector ) ->
  ( event ) -> ( event.target.closest? selector )?

within = ( selector, fx ) ->
  K.test ( _within selector ), Fn.pipe fx

export { within }
