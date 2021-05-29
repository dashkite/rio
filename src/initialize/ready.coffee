import {flow, pipe} from "@dashkite/joy/function"
import {test, pop} from "@dashkite/katana/sync"
import {event} from "./event"
import {local, intercept} from "../event"

ready = (fx) ->
  event "ready", [
    test local, pipe [
      intercept
      flow fx
  ] ]

export {ready}
