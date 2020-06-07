import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  bind
  event
  matches
  intercept
  discard
  form
} from "../../../src"

Greetings = put: (data) -> Promise.resolve (window.greeting = data)

class extends Handle

  mixin @, [
    tag "x-create-greeting"
    diff
    connect [
      shadow
      bind ->
        @html = """
          <form>
            <input name='name' type='text'/>
          </form>
        """
      event "submit", [
        matches "form"
        intercept
        discard
        form
        bind (data) -> Greetings.put data
      ]

    ]
  ]
