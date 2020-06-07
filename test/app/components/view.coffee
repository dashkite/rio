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
} from "../../../src"

Greetings = get: (key) ->
  Promise.resolve if key == "alice" then "Hello, Alice!"


class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      describe [
        bind -> @data.greeting = await Greetings.get @description.name
      ]
      observe "data", [
        bind -> @html = "<p>#{@data.greeting}</p>"
      ]
    ]
  ]
