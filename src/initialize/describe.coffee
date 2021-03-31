import {speek, push} from "@dashkite/katana"
import {curry, flow} from "@dashkite/joy/function"
import {description} from "../actions/description"

_describe = curry (handler, handle) ->
  observer = new MutationObserver (list) ->
    if (list.find (record) -> /^data\-/.test record.attributeName)?
      handler [ {handle} ]

  observer.observe handle.dom, attributes: true
  handler [ {handle} ]

describe = (fx) -> speek _describe flow [ description, fx... ]

describe._ = _describe

export {describe}
