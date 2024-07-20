import { curry, flow } from "@dashkite/joy/function"
import { event } from "./event"
import { within, intercept } from "../event"

make = ( name ) ->
  curry ( selector, fx ) ->
    event name, [
      within selector, [
        intercept,
        flow fx
      ]
    ]

keyup = make "keyup"
keydown = make "keydown"
input = make "input"

export { keyup, keydown, input }
