import {poke, peek} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe, description,
  observe, render, assign, bind, event, matches, intercept, discard,
  form } from "../../../src"
import Greetings from "./greetings"

swap = (stack) -> [ stack[1], stack[0], stack[2...]... ]
swapr = (stack) -> [ stack[0], stack[2], stack[1], stack[3...]... ]

template = ({data}) ->
  """
    <form>
      <input name='salutation' type='text' value='#{data.salutation}'/>
      <input name='name' type='text' value='#{data.name}'/>
    </form>
  """

class extends Handle

  mixin @, [
    tag "x-update-greeting"
    diff
    connect [
      shadow
      observe "data", [ render template ]
      describe [
        poke Greetings.get
        assign "data"
      ]
      event "submit", [
        matches "form"
        intercept
        discard
        form
        swap
        description
        swapr
        peek Greetings.put
      ]

    ]
  ]
