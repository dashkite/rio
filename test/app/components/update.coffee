import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
  observe
  bind
  event
  matches
  intercept
  discard
  form
} from "../../../src"

import Greetings from "./greetings"

class extends Handle

  mixin @, [
    tag "x-update-greeting"
    diff
    connect [
      shadow
      describe [
        bind -> Object.assign @data, await Greetings.get @description.key
      ]
      observe "data", [
        bind ->
          @html = """
            <form>
              <input name='salutation' type='text' value='#{@data.salutation}'/>
              <input name='name' type='text' value='#{@data.name}'/>
            </form>
          """
      ]
      event "submit", [
        matches "form"
        intercept
        discard
        form
        bind (data) -> Greetings.put @description.key, data
      ]

    ]
  ]
