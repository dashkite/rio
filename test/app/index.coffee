import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
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
    ]

  ]
