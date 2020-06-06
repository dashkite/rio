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
  intercept
  bind
} from "../../src"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      describe [
        bind -> @greeting = @description.greeting
      ]
      observe "data", [
        bind -> @fullGreeting = "#{@description.greeting}, #{@data.name}!"
      ]
      event "click", [
        matches "p"
        intercept
        discard
        bind -> @clicked = true
      ]
      event "click", [
        matches "h1"
        intercept
        discard
        bind -> @clicked = false
      ]
    ]

  ]
