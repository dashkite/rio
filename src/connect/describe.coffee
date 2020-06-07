import {curry, flow} from "@pandastrike/garden"
import {readonly} from "../helpers"

describe = curry (fx, handle) ->
  readonly handle, description: -> Object.assign {}, @dom.dataset
  handler = flow fx
  observer = new MutationObserver -> handler [ handle ]
  observer.observe handle.dom, attributes: true
  handler [ handle ]

export {describe}
