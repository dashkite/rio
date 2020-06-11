import {flow, pipe} from "@pandastrike/garden"
import {stest, spop} from "@dashkite/katana"
import {event} from "./event"
import {local} from "../event/local"

discard = spop ->

ready = (fx) ->
  event "ready", [
    stest local, pipe [
      discard
      flow fx
  ] ]

export {ready}
