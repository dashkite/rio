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
  discard
  bind
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
        discard
        bind -> @clicked = true
      ]
      event "click", [
        matches "h1"
        discard
        bind -> @clicked = false
      ]
    ]

  ]
