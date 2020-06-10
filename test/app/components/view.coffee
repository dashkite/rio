import {flow} from "@pandastrike/garden"
import {peek, poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe, description,
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
      describe flow [
        push description
        poke Greetings.get
        peek assign "data"
      ]
    ]
  ]
