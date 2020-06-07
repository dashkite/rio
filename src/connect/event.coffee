import {curry, flow} from "@pandastrike/garden"

event = curry (name, fx, [handle]) ->
  handler = (stack) ->
    for f in fx
      tbd = f stack
      stack = if tbd.then? then (await tbd) else tbd
      break if !stack[0]?
    stack

  handle.root.addEventListener name, (event) -> handler [ event, handle ]

export {event}
