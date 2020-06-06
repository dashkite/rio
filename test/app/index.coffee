import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
  observe
  event
} from "../../src"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      describe [
        ([handle]) ->
          handle.greeting = handle.description.greeting
      ]
      observe "data", [
        ([handle]) ->
          handle.fullGreeting = "#{handle.description.greeting},
            #{handle.data.name}!"
      ]
      event "click", [
        ([event, handle]) -> handle.clicked = true
      ]
    ]

  ]
