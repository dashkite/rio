import {poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe, observe, render,
  assign, bind } from "../../../src"

import Greetings from "./greetings"

template = ({data}) -> "<p>#{data.salutation}, #{data.name}!</p>"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      observe "data", [ render template ]
      describe [
        poke Greetings.get
        assign "data"
      ]
    ]
  ]