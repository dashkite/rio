import * as _ from "@dashkite/joy"
import * as c from "@dashkite/carbon"
import Greetings from "./greetings"

class extends c.Handle

  _.mixin @, [
    c.tag "x-create-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.sheets main: "form { color: blue; }"
      c.submit "form", [
        c.call Greetings.put
      ]
      c.activate [
        c.render ->
          """
          <form>
            <input name='key' type='text'/>
            <input name='salutation' type='text'/>
            <input name='name' type='text'/>
          </form>
          """
      ]
    ]
  ]
