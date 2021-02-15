import {curry, pipe} from "@pandastrike/garden"
import {spush, read} from "@dashkite/katana"

_dispatch = curry (name, handle) -> handle.dispatch name

dispatch = (name) ->
  pipe [
    read "handle"
    spush _dispatch name
  ]

dispatch._ = _dispatch

export {dispatch}
