import {curry, pipe} from "@pandastrike/garden"
import {stest} from "@dashkite/katana"

# TODO we may want to explore alternative implementations or even
#      additional combinators that use the composedPath method to
#      allow us to handle events originating from slotted DOM

_matches = curry (selector, event, {handle}) ->
  if (target = (event?.target?.closest? selector))?
    if handle.root.contains target
      event._target = target
      true
    else
      false

matches = (selector, fx) -> stest (_matches selector), pipe fx

matches._ = _matches

# migrate matches to use the matches DOM method
contains = matches

export {matches, contains}
