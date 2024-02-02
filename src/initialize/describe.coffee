import { peek } from "@dashkite/katana/sync"
import { Daisho } from "@dashkite/katana"
import { curry, flow } from "@dashkite/joy/function"
import { isEmpty } from "@dashkite/joy/value"

updates = ( record ) -> /^data\-/.test record.attributeName

_describe = curry ( handler, handle ) ->
  _handler = ->
    description = { handle.dom.dataset... }
    handler Daisho.create [ description ], { handle }
  observer = new MutationObserver ( list ) ->
    do _handler if ( list.find updates )?
  observer.observe handle.dom, attributes: true
  do _handler
  return

describe = ( fx ) -> peek _describe flow fx

export { describe }
