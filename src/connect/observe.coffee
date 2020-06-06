import {curry, flow} from "@pandastrike/garden"

observe = curry (fx, handle) ->
  handler = flow fx
  handle.update = (f) ->
    await f.call @
    handler [ @ ]

export {observe}
