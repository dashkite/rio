import {Observable} from "object-observer"
import {curry, flow} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

# TODO do we want a debounce here?
#      Object.assign will trigger N change events
#      instead of batching them up
_observe = curry (name, handler, handle) ->
  wrapper = Observable.from handle[name] ? {}
  Object.defineProperty handle, name,
    value: wrapper
    writeable: false
  wrapper.observe (changes) -> handler [ wrapper, {handle} ]

observe = (name, fx) -> speek _observe name, flow fx

observe._ = _observe

export {observe}
