import { tee, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"
import { form } from "../actions"

submit = ( fx ) ->
  event "submit", [
    intercept
    form
    flow fx 
  ]

export { submit }
