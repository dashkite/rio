import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"

import { attributes } from "../actions/attributes"
import { dom } from "../actions/get"

_modify = curry ( names, handler, handle ) ->
  observer = new MutationObserver -> handler { handle }
  observer.observe handle.dom, attributes: true, attributeFilter: names
  for [ name ] in handle.dom.attributes when name in names
    handler { handle }
    break
  # avoid returning promise
  undefined

modify = ( names, fx ) -> 
  peek _modify names, flow [ dom, attributes, fx... ]

export { modify }
