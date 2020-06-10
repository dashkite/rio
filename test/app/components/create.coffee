import {push, peek, poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, render, bind, event,
  matches, intercept, discard, form, description } from "../../../src"
import Greetings from "./greetings"

dup = (stack) -> [ stack[0], stack[0], stack[1...]... ]
swap = (stack) -> [ stack[1], stack[0], stack[2...]... ]

template = ->
  """
    <form>
      <input name='key' type='text'/>
      <input name='salutation' type='text'/>
      <input name='name' type='text'/>
    </form>
  """

class extends Handle

  mixin @, [
    tag "x-create-greeting"
    diff
    connect [
      shadow
      render template
      event "submit", [
        matches "form"
        intercept
        discard
        form
        push ({name, salutation}) -> {name, salutation}
        swap
        poke ({key}) -> {key}
        peek Greetings.put
      ]

    ]
  ]
