import { Observable } from "object-observer"
import { curry, flow } from "@dashkite/joy/function"
import { read  } from "@dashkite/katana/async"
import { peek } from "@dashkite/katana/sync"

_observe = curry ( name, handler, handle ) ->
  wrapper = Observable.from (handle[name] ? {}), async: true
  Object.defineProperty handle, name,
    value: wrapper
    writable: true
  Observable.observe wrapper, -> handler { data: wrapper, handle }

observe = ( name, fx ) ->
  peek _observe name, flow [
    read "data"
    flow fx
  ]

export { observe }
