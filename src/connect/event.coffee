import {curry, pipe} from "@pandastrike/garden"

event = curry (name, handler, [handle]) ->
  handle.root.addEventListener name, (event) -> handler [ event, handle ]

export {event}
