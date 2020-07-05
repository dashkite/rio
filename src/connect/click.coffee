import {curry, pipe} from "@pandastrike/garden"
import {event} from "./event"
import {matches, intercept} from "../event"

click = curry (selector, fx) ->
  event "click", [ matches selector, [ pipe fx ] ]

export {click}
