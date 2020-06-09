import {
  Handle
  mixin
  tag
  diff
  connect
  shadow
  describe
  observe
  render
  bind
} from "../../../src"

import Greetings from "./greetings"

template = ({data}) -> "<p>#{data.salutation}, #{data.name}!</p>"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
      describe [
        bind -> Object.assign @data, await Greetings.get @description.key
      ]
      observe "data", [ render template ]
    ]
  ]
