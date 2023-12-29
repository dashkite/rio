import * as _ from "@dashkite/joy"
import * as R from "@dashkite/rio"
import Greetings from "./greetings"

class extends R.Handle

  _.mixin @, [
    R.tag "x-create-greeting"
    R.diff
    R.initialize [
      R.shadow
      R.sheets main: "form { color: blue; }"
      R.submit "form", [
        R.call Greetings.put
      ]
      R.activate [
        R.render ->
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
