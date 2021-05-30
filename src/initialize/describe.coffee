import {peek} from "@dashkite/katana/sync"
import {curry, flow} from "@dashkite/joy/function"
import {description} from "../actions/description"

_describe = curry (handler, handle) ->
  observer = new MutationObserver (list) ->
    if (list.find (record) -> /^data\-/.test record.attributeName)?
      handler { handle }

  observer.observe handle.dom, attributes: true
  handler { handle }
  # avoid returning a promise
  # TODO this is a bug with rtee transforming into a promise
  #      returning function
  undefined

describe = (fx) -> peek _describe flow [ description, fx... ]

describe._ = _describe

export {describe}
