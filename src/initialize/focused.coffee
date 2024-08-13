import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

focused = curry ( selector, fx ) ->
  event "focused", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

export { focused }
