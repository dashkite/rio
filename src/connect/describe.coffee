import {push} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"
import {readonly} from "../helpers"
import {description} from "../actions/description"

describe = curry (fx, [handle]) ->
  handler = flow [ (push description), fx... ]
  observer = new MutationObserver -> handler [ handle ]
  observer.observe handle.dom, attributes: true
  handler [ handle ]

export {describe}
