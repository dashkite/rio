import {flow} from "@pandastrike/garden"
import {peek, poke} from "@dashkite/katana"
import { Handle, mixin, tag, diff, initialize, connect, shadow, describe,
  observe, render, assign, bind, event, matches, intercept, discard,
  description, form} from "../../../src"
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
    initialize [ shadow ]
    connect [
      observe "data", [ render template ]
      describe [
        poke Greetings.get
        assign "data"
      ]
      event "submit", [
        matches "form", [
          intercept
          flow [
            form
            description
            peek Greetings.put
  ] ] ] ] ]
