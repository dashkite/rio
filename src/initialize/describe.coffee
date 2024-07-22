import { peek } from "@dashkite/katana/sync"
import { Daisho } from "@dashkite/katana"
import { curry, flow } from "@dashkite/joy/function"
import { isEmpty } from "@dashkite/joy/value"

updates = ( record ) -> /^data\-/.test record.attributeName

prepare = ( handle ) -> 
  Daisho.create [{ handle.dom.dataset... }, handle ], { handle }

describe = ( fx ) ->
  handler = flow fx
  peek ( handle ) ->
    observer = new MutationObserver ( list ) -> 
      ( handler prepare handle ) if ( list.find updates )?
    observer.observe handle.dom, attributes: true

export { describe }
