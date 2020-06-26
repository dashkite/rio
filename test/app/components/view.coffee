import {pipe} from "@pandastrike/garden"
import {poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, initialize, connect, shadow, describe,
  observe, render, assign } from "../../../src"

import Greetings from "./greetings"

template = (data) -> "<p>#{data.salutation}, #{data.name}!</p>"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    initialize [ shadow ]
    connect [
      observe "data", [ render template ]
      describe [
        poke Greetings.get
        assign "data"
  ] ] ]
