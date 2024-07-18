import { curry, flow } from "@dashkite/joy/function"
import { capture } from "./capture"
import { within, intercept } from "../event"

toggle = curry ( selector, fx ) ->
  capture "toggle", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

export { toggle }
