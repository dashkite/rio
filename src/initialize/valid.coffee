import { flow, pipe } from "@dashkite/joy/function"
import { read, peek } from "@dashkite/katana/sync"
import { intercept } from "../event"
import { form } from "../actions"

valid = ( fx ) ->
  pipe [
    read "handle"
    peek ( handle ) ->
      handle.dom.addEventListener "valid", 
        pipe [
          ( event ) -> { handle, event }
          read "event"
          intercept
          flow [ form, fx... ]
        ]
  ]

export { valid }
