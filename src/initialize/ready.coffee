import { flow, pipe } from "@dashkite/joy/function"
import { test } from "@dashkite/katana/sync"
import { event } from "./event"
import { intercept } from "../event"

local = ( event, {handle}) -> event.detail == handle

ready = ( fx ) ->
  event "ready", [
    test local, pipe [
      intercept
      flow fx
  ] ]

export { ready }
