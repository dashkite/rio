import {curry, flow, tee} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

sleep = (interval) ->
  new Promise (resolve) ->
    setTimeout resolve, interval

# start and stop are tedious because we want to be careful to have idempotent starts with only one loop. We also gracefully do nothing with undefined polls to avoid mystery bugs.
_startPoll = curry (name, interval, handle) ->
  unless handle.polls?[name]?
    console.warn "no poll #{name} is defined for this Carbon handle."
    return

  if !(handle.polls[name].active)?
    handle.polls[name].active = true
    do ->
      loop
        if handle.polls?[name]?.active == true
          await handle.polls[name].f()
        await sleep interval
  else
    handle.polls[name].active = true

_stopPoll = curry (name, handle) ->
  if handle.polls?[name]?.active?
    handle.polls[name].active = false


startPoll = (name, interval) -> tee flow [
  read "handle"
  pop _startPoll name, interval
]

startPoll._ = _startPoll


stopPoll = (name) -> tee flow [
  read "handle"
  pop _stopPoll name
]

stopPoll._ = _stopPoll


export {startPoll, stopPoll}
