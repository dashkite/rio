import {speek} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"

_poll = curry (name, handler, handle) ->
  handle.polls ?= {}
  handle.polls[name] = f: -> handler [ {handle} ]

poll = (name, fx) -> speek _poll name, flow fx

poll._ = _poll

export {poll}
