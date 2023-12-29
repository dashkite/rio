import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as R from "@dashkite/rio"

import Greetings from "./greetings"

class extends R.Handle

  _.mixin @, [
    R.tag "x-greeting"
    R.diff
    R.initialize [
      R.shadow
      R.describe [
        k.poke Greetings.get
        R.render (data) -> "<p>#{data.salutation}, #{data.name}!</p>"
  ] ] ]
