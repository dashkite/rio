import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"
import { form } from "../actions"

submit = curry ( selector, fx ) ->
  event "submit", [
    within selector, [
      intercept
      flow [
        form
        fx...
      ]
    ]
  ]

export { submit }
