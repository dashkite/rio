import {pipe, flow} from "@pandastrike/garden"
import {pushn, spop as pop, peek, poke, stest as test} from "@dashkite/katana"
import { Handle, mixin, tag, diff, connect, shadow, describe, description,
  observe, render, assign, bind, event, matches, intercept, discard,
  form } from "../../../src"
import Greetings from "./greetings"

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
      observe "data", [ peek render template ]
      describe [
        poke Greetings.get
        peek assign "data"
      ]
      event "submit", [
        test (matches "form"), pipe [
          pop intercept
          flow [
            pushn [
              description
              form
            ]
            peek Greetings.put
          ] ] ] ] ]
