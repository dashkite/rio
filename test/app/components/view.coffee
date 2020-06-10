import {pipe, flow} from "@pandastrike/garden"
import {push, peek, speek, poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe, description,
  observe, render, assign } from "../../../src"

import Greetings from "./greetings"

template = ({data}) -> "<p>#{data.salutation}, #{data.name}!</p>"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      speek shadow
      speek observe "data", flow [ peek render template ]
      speek describe flow [
        push description
        poke Greetings.get
        peek assign "data"
      ]
    ]
  ]
