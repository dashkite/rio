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
  matches
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
        matches "p"
        ([event, handle]) -> handle.clicked = true
      ]
      event "click", [
        matches "h1"
        ([event, handle]) -> handle.clicked = false
      ]
    ]

  ]
