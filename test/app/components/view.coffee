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

import Greetings from "./greetings"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      describe [
        bind -> Object.assign @data, await Greetings.get @description.key
      ]
      observe "data", [
        bind ->
          @html = """
            <p>#{@data.salutation}, #{@data.name}!</p>
          """
      ]
    ]
  ]
