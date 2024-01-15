import * as _ from "@dashkite/joy"
import * as R from "@dashkite/rio"
import Greetings from "./greetings"

html = (data) ->
  """
  <form>
    <input name='salutation' type='text' value='#{data.salutation}'/>
    <input name='name' type='text' value='#{data.name}'/>
  </form>
  """

class extends R.Handle

  _.mixin @, [
    R.tag "x-update-greeting"
    R.diff
    R.initialize [
      R.shadow
      R.describe [
        R.call Greetings.get
        R.render html
      ]
      R.submit "form", [
        R.description
        R.call ({ key }, data) -> Greetings.put {key, data...}
      ]
] ]
