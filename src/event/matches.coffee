import {curry, pipe} from "@dashkite/joy/function"
import {test} from "@dashkite/katana/sync"

_matches = curry (selector, event, {handle}) ->
  if (event?.target?.matches selector)?
    true
  else
    false

matches = (selector, fx) -> test (_matches selector), pipe fx

matches._ = _matches

export {matches}
