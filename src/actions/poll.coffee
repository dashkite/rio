import {curry, flow, tee} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

sleep = (interval) ->
  new Promise (resolve) ->
    setTimeout resolve, interval

_startPoll = curry (name, interval, handle) ->
  if (f = handle.polls?[name]?.f)?
    handle.polls[name].active = true

    do g = ->
      await f()
      await sleep interval
      if handle.polls[name]?.active == true
        g()

_stopPoll = curry (name, handle) ->
  if handle.polls?[name]?
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
