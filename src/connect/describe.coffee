import {push} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"
import {readonly} from "../helpers"
import {description} from "../actions/description"

describe = curry (handler, handle) ->
  observer = new MutationObserver -> handler [ handle ]
  observer.observe handle.dom, attributes: true
  handler [ handle ]

export {describe}
