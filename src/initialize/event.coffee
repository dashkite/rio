import { read, peek } from "@dashkite/katana/sync"
import { curry, pipe } from "@dashkite/joy/function"

_event = curry ( name, handler, handle ) ->

event = ( name, fx ) ->
  handler = pipe [
    read "handle"
    read "event"
    fx...
  ]
  peek ( handle ) ->
    handle.on name, ( event ) -> handler { handle, event }
  
export { event }
