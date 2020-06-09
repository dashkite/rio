import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  render
  bind
  event
  matches
  intercept
  discard
  form
} from "../../../src"

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
    connect [
      shadow
      render template
      event "submit", [
        matches "form"
        intercept
        discard
        form
        bind (data) -> Greetings.put data.key, data
      ]

    ]
  ]
