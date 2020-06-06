import {curry, flow} from "@pandastrike/garden"

event = curry (name, fx, handle) ->
  handler = (stack) ->
    for f in fx
      stack = await f stack
      break if !stack[0]?
    stack

  handle.root.addEventListener name, (event) -> handler [ event, handle ]

export {event}
