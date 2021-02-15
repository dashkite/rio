import * as g from "@pandastrike/garden"
import * as k from "@dashkite/katana"
import * as c from "../../../src"

import Greetings from "./greetings"

class extends c.Handle

  c.mixin @, [
    c.tag "x-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.describe [
        k.poke Greetings.get
        c.render (data) -> "<p>#{data.salutation}, #{data.name}!</p>"
  ] ] ]
