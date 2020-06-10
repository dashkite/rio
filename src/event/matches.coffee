import {curry} from "@pandastrike/garden"

matches = curry (selector, event, handle) ->
  if (target = (event?.target?.closest? selector))?
    event if handle.root.contains target

export {matches}
