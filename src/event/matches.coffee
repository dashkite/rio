import {spoke as poke} from "@dashkite/katana"

matches = (selector) ->
  poke (event, handle) ->
    if (target = (event?.target?.closest? selector))?
      event if handle.root.contains target

export {matches}
