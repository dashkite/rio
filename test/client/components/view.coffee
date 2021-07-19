import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as c from "@dashkite/carbon"

import Greetings from "./greetings"

class extends c.Handle

  _.mixin @, [
    c.tag "x-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.activate [
        c.description
        k.poke Greetings.get
        c.render (data) -> "<p>#{data.salutation}, #{data.name}!</p>"
  ] ] ]
