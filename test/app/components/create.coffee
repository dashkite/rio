import {pipe, flow, curry} from "@pandastrike/garden"
import {push, spop, peek, speek, poke, pushn, stest} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, render, bind, event,
  matches, intercept, discard, form, description } from "../../../src"
import Greetings from "./greetings"
project = curry (ax, b) -> ax.reduce ((r, a) -> {r..., [a]: b[a]}), {}

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
      speek render template
      speek event "submit", pipe [
        stest (matches "form"), pipe [
          spop intercept
          flow [
            push form
            pushn [
              project [ "key" ]
              project [ "name", "salutation" ]
            ]
            peek Greetings.put
          ] ] ] ] ]
