import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, prevent } from "../event"

dragover = curry ( selector, fx ) ->
  event "dragover", [
    within selector, [
      prevent
      flow fx 
    ]
  ]

dragOver = dragover
export { dragover, dragOver }
