import { read, peek } from "@dashkite/katana/sync"
import { curry, pipe } from "@dashkite/joy/function"

_event = curry ( name, handler, handle ) ->
  handle.on name, ( event ) -> handler { handle, event }

event = ( name, fx ) ->
  peek _event name, pipe [
    read "handle"
    read "event"
    fx...
  ]

event._ = _event

export { event }
