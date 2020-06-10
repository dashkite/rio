import {speek} from "@dashkite/katana"
import {curry, pipe} from "@pandastrike/garden"

_event = curry (name, handler, handle) ->
  handle.root.addEventListener name, (event) -> handler [ event, handle ]

event = (name, fx) -> speek _event name, pipe fx

export {event}
