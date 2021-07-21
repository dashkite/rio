import * as _ from "@dashkite/joy"
import * as c from "@dashkite/carbon"
import Greetings from "./greetings"

html = (data) ->
  """
  <form>
    <input name='salutation' type='text' value='#{data.salutation}'/>
    <input name='name' type='text' value='#{data.name}'/>
  </form>
  """

class extends c.Handle

  _.mixin @, [
    c.tag "x-update-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.describe [
        c.call Greetings.get
        c.render html
      ]
      c.submit "form", [
        c.description
        c.call ({key}, data) -> Greetings.put {key, data...}
      ]
] ]
