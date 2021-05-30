import {curry, flow} from "@dashkite/joy/function"
import * as k from "@dashkite/katana/sync"
import {event} from "./event"
import {within, intercept} from "../event"
import {form} from "../actions"

submit = curry (selector, fx) ->
  event "submit", [
    within selector, [
      intercept
      flow [
        form
        fx...
      ]
    ]
  ]

export {submit}
