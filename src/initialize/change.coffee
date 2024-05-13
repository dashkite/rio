import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

change = curry ( selector, fx ) ->
  event "change", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

export { change }
