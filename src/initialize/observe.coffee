import {Observable} from "object-observer"
import {curry, flow} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

_observe = curry (name, handler, handle) ->
  wrapper = Observable.from (handle[name] ? {}), async: true
  Object.defineProperty handle, name,
    value: wrapper
    writeable: false
  wrapper.observe -> handler [ wrapper, {handle} ]

observe = (name, fx) -> speek _observe name, flow fx

observe._ = _observe

export {observe}
