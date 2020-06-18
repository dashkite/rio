import {Observable} from "object-observer"
import {curry, flow} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

_observe = curry (name, handler, handle) ->
  wrapper = Observable.from handle[name] ? {}
  Object.defineProperty handle, name,
    value: wrapper
    writeable: false
  wrapper.observe -> handler [ {handle} ]

observe = (name, fx) -> speek _observe name, flow fx

export {observe, _observe}
