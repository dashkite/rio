import { flow, pipe } from "@dashkite/joy/function"
import { read, peek } from "@dashkite/katana/sync"
import { form } from "./form"
import { intercept } from "../event"

invalid = ( fx ) ->
  pipe [
    read "handle"
    peek ( handle ) ->
      handle.dom.addEventListener "invalid", 
        pipe [
          ( event ) -> { handle, event }
          read "event"
          intercept
          # TODO filter out the valid elements?
          flow [ form, fx... ]
        ]
  ]

export { invalid }
