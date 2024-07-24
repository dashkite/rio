import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, prevent } from "../event"

drop = curry ( selector, fx ) ->
  event "drop", [
    within selector, [
      prevent
      flow fx 
    ]
  ]

export { drop }
