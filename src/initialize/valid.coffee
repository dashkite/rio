import {flow, pipe} from "@dashkite/joy/function"
import {read, peek} from "@dashkite/katana/sync"
import {event} from "./event"
import {intercept} from "../event"

valid = (fx) ->
  pipe [
    read "handle"
    peek ( handle ) ->
      handle.dom.addEventListener "valid", 
        pipe [
          ( event ) -> { handle, event }
          read "event"
          intercept
          flow fx
        ]
  ]

export {valid}
