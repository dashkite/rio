import {curry, pipe} from "@pandastrike/garden"
import {spop, read} from "@dashkite/katana"

_dispatch = curry (name, handle) -> handle.dispatch name

dispatch = (name) ->
  pipe [
    read "handle"
    spop _dispatch name
  ]

dispatch._ = _dispatch

export {dispatch}
