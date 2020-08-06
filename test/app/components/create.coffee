import {flow, curry} from "@pandastrike/garden"
import {peek} from "@dashkite/katana"
import { Handle, mixin, tag, diff, initialize, connect,
  shadow, sheet, render, ready, event,
  matches, intercept, discard, form } from "../../../src"
import Greetings from "./greetings"

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
    initialize [
      shadow
      sheet -> "form { color: blue; }"
    ]
    connect [
      ready [ render template ]
      event "submit", [
        matches "form", [
          intercept
          flow [
            form
            peek Greetings.put
          ] ] ] ] ]
