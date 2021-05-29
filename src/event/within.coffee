import {curry, pipe} from "@dashkite/joy/function"
import {test} from "@dashkite/katana/sync"

# TODO we may want to explore alternative implementations or even
#      additional combinators that use the composedPath method to
#      allow us to handle events originating from slotted DOM

_within = curry (selector, event, {handle}) ->
  if (target = (event?.target?.closest? selector))?
    if handle.root.contains target
      event._target = target
      true
    else
      false

within = (selector, fx) -> test (_within selector), pipe fx

within._ = _within

export {within}
