import {curry, pipe} from "@pandastrike/garden"
import {event} from "./event"
import {within, intercept} from "../event"

submit = curry (selector, fx) ->
  event "submit", [ within selector, [ intercept, flow fx ] ]

export {submit}
