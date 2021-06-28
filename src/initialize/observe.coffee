import {Observable} from "object-observer"
import {curry, flow} from "@dashkite/joy/function"
import {read} from "@dashkite/katana/async"
import {peek} from "@dashkite/katana/sync"

_observe = curry (name, handler, handle) ->
  wrapper = Observable.from (handle[name] ? {}), async: true
  Object.defineProperty handle, name,
    value: wrapper
    writeable: false
  wrapper.observe -> handler { data: wrapper, handle }

observe = (name, fx) ->
  peek _observe name, flow [
    read "data"
    flow fx
  ]

observe._ = _observe

export {observe}
