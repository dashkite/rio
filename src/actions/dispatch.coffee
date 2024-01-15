import { curry, pipe } from "@dashkite/joy/function"
import { pop, read } from "@dashkite/katana/sync"

_dispatch = curry ( name, handle, detail ) -> handle.dispatch name, detail

dispatch = ( name ) ->
  pipe [
    read "handle"
    pop _dispatch name
  ]

dispatch._ = _dispatch

export { dispatch }
