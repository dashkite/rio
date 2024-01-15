import * as F from "@dashkite/joy/function"
import * as Ks from "@dashkite/katana/sync"

capture = ( name, fx ) ->
  Ks.peek ( handle ) ->
    handler = F.pipe [
      Ks.read "handle"
      Ks.read "event"
      F.pipe fx
    ]
    handle.root.addEventListener name,
      (( event ) -> handler { handle, event }),
      capture: true

export { capture }
