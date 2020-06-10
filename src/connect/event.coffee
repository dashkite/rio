import {curry, pipe} from "@pandastrike/garden"

event = curry (name, fx, [handle]) ->
  handler = pipe fx
  handle.root.addEventListener name, (event) -> handler [ event, handle ]

export {event}
