import * as c from "../../../src"
import Greetings from "./greetings"

class extends c.Handle

  c.mixin @, [
    c.tag "x-update-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.submit "form", [
        c.description
        c.call ({key}, data) -> Greetings.put {key, data...}
      ]
      c.describe [
        c.call Greetings.get
        c.render (data) ->
          """
          <form>
            <input name='salutation' type='text' value='#{data.salutation}'/>
            <input name='name' type='text' value='#{data.name}'/>
          </form>
          """
] ] ]
