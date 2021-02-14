import {curry, pipe} from "@pandastrike/garden"
import {stest} from "@dashkite/katana"

_matches = curry (selector, event, {handle}) ->
  if (event?.target?.matches selector)?
    true
  else
    false

matches = (selector, fx) -> stest (_matches selector), pipe fx

matches._ = _matches

export {matches}
