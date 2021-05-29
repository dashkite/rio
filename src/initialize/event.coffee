import {peek} from "@dashkite/katana/sync"
import {curry, pipe} from "@dashkite/joy/function"

_event = curry (name, handler, handle) ->
  handle.on name, (event) -> handler [ event, {handle} ]

event = (name, fx) -> peek _event name, pipe fx

event._ = _event

export {event}
