import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

dblclick = curry ( selector, fx ) ->
  event "dblclick", [
    within selector, [
      intercept,
      flow fx
    ]
  ]

doubleClick = dblclick

export { dblclick, doubleClick }
