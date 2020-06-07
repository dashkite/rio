import {Observable} from "object-observer"
import {curry, flow} from "@pandastrike/garden"

observe = curry (name, fx, [handle]) ->
  handler = flow fx
  wrapper = Observable.from handle[name] ? {}
  Object.defineProperty handle, name,
    value: wrapper
    writeable: false
  wrapper.observe -> handler [ handle ]

export {observe}
