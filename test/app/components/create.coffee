import {pipe, flow, curry} from "@pandastrike/garden"
import {push, spop as pop, peek, poke, pushn, stest as test} from "@dashkite/katana"
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
      peek render template
      event "submit", [
        test (matches "form"), pipe [
          pop intercept
          flow [
            push form
            pushn [
              project [ "key" ]
              project [ "name", "salutation" ]
            ]
            peek Greetings.put
          ] ] ] ] ]
