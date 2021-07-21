import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"
import { attributes } from "../actions/attributes"

_modify = curry (names, handler, handle) ->
  observer = new MutationObserver (list) -> handler { handle }
  observer.observe handle.dom, attributes: true, attributeFilter: names
  for [ name, value ] in handle.dom.attributes when name in names
    handler { handle }
    break
  # avoid returning promise
  undefined

modify = (names, fx) -> peek _modify names, flow [ description, fx... ]

modify._ = _modify

export { modify }
