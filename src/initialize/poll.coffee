import * as Fn from "@dashkite/joy/function"
import * as Time from "@dashkite/joy/time"
import { call } from "../actions/call"

# TODO make cancelable

poll = ( interval, fx ) ->
  handler = Fn.flow fx
  call ->
    handle = @
    do ->
      loop
        await Time.sleep interval
        handler { handle }
      return
    return

export { poll }