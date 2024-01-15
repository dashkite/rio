import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

click = curry ( selector, fx ) ->
  event "click", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

export { click }
