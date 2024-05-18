import { curry, pipe } from "@dashkite/joy/function"
import { pop, read } from "@dashkite/katana/sync"

dispatch = ( name ) ->
  pipe [
    read "handle"
    pop ( handle, detail ) -> 
      handle.dispatch name, detail
  ]

export { dispatch }
