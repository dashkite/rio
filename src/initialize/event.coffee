import {speek} from "@dashkite/katana"
import {curry, pipe} from "@dashkite/joy/function"

_event = curry (name, handler, handle) ->
  handle.on name, (event) -> handler [ event, {handle} ]

event = (name, fx) -> speek _event name, pipe fx

event._ = _event

export {event}
