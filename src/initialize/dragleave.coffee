import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, prevent } from "../event"

dragleave = curry ( selector, fx ) ->
  event "dragleave", [
    within selector, [
      prevent
      flow fx 
    ]
  ]

dragLeave = dragleave
export { dragleave, dragLeave }
