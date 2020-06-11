import {curry, pipe} from "@pandastrike/garden"
import {stest} from "@dashkite/katana"

_matches = curry (selector, event, handle) ->
  if (target = (event?.target?.closest? selector))?
    event if handle.root.contains target

matches = (selector, fx) -> stest (_matches selector), pipe fx

export {matches, _matches}
