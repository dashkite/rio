import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

dragstart = curry ( selector, fx ) ->
  event "dragstart", [
    within selector, [ flow fx ]
  ]

dragStart = dragstart

export { dragstart, dragStart }
