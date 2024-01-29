import * as k from "@dashkite/katana/sync"
import { flow, pipe } from "@dashkite/joy/function"
import { read, peek } from "@dashkite/katana/sync"
import { form } from "../actions/form"
import { prevent } from "../event"

invalid = ( fx ) ->
  pipe [
    capture "invalid", [
      prevent
      target
      k.poke ( target ) ->
        name: target.name
        message: target.validationMessage
        target: target
      k.peek flow fx
    ]
  ]


export { invalid }
