import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

focusin = curry ( selector, fx ) ->
  event "focusin", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

focusout = curry ( selector, fx ) ->
  event "focusout", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

export { focusin, focusout }
