import {pipe, flow} from "@pandastrike/garden"
import {push, pushn, spop, peek, speek, poke, stest} from "@dashkite/katana"
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
        assign "data"
      ]
      event "submit", [
        stest (matches "form"), pipe [
          spop intercept
          flow [
            pushn [
              description
              form
            ]
            peek Greetings.put
          ] ] ] ] ]
