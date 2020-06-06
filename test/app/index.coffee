import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
  observe
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
      observe [
        ([handle]) ->
          console.log "changing"
          handle.fullGreeting = "#{handle.description.greeting},
            #{handle.name}!"
      ]
    ]

  ]
