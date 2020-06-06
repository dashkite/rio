import {curry, flow} from "@pandastrike/garden"

event = curry (name, fx, handle) ->
  handler = flow fx
  handle.root.addEventListener name, (event) -> handler [ event, handle ]

export {event}
