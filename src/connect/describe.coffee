import {speek, push} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"
import {description} from "../actions/description"

_describe = curry (handler, handle) ->
  observer = new MutationObserver -> handler [ {handle} ]
  observer.observe handle.dom, attributes: true
  handler [ {handle} ]

describe = (fx) -> speek _describe flow [ description, fx... ]

describe._ = _describe

export {describe}
