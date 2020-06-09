import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
  observe
  render
  bind
  event
  matches
  intercept
  discard
  form
} from "../../../src"

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
      describe [
        bind -> Object.assign @data, await Greetings.get @description.key
      ]
      observe "data", [ render template ]
      event "submit", [
        matches "form"
        intercept
        discard
        form
        bind (data) -> Greetings.put @description.key, data
      ]

    ]
  ]
