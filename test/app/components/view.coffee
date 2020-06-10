import {pipe, flow} from "@pandastrike/garden"
import {push, peek, speek, poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe,
  observe, render, assign } from "../../../src"

import Greetings from "./greetings"

template = ({data}) -> "<p>#{data.salutation}, #{data.name}!</p>"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      observe "data", [ peek render template ]
      describe [
        poke Greetings.get
        assign "data"
      ]
    ]
  ]
