import {curry, pipe} from "@pandastrike/garden"
import {stest} from "@dashkite/katana"

# TODO we may want to explore alternative implementations or even
#      additional combinators that use the composedPath method to
#      allow us to handle events originating from slotted DOM

_matches = curry (selector, event, {handle}) ->
  if (target = (event?.target?.closest? selector))?
    handle.root.contains target

matches = (selector, fx) -> stest (_matches selector), pipe fx

matches._ = _matches

export {matches}
