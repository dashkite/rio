import {flow, pipe} from "@pandastrike/garden"
import {stest, spop} from "@dashkite/katana"
import {event} from "./event"
import {local, intercept} from "../event"

ready = (fx) ->
  event "ready", [
    stest local, pipe [
      intercept
      flow fx
  ] ]

export {ready}
