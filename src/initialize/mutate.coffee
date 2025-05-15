import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"

_mutate = curry ( handler, handle ) ->
  observer = new MutationObserver -> handler { handle }
  observer.observe handle.dom, childList: true
  # handler { handle }
  # avoid returning promise
  undefined

mutate = ( fx ) -> peek _mutate flow fx

mutate._ = _mutate

export { mutate }
