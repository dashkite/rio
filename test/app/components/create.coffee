import * as k from "@dashkite/katana"
import * as c from "../../../src"
import Greetings from "./greetings"

class extends c.Handle

  c.mixin @, [
    c.tag "x-create-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.sheet main: "form { color: blue; }"
      c.submit "form", [
        k.peek Greetings.put
      ]
      c.activate [
        c.render -> """
          <form>
            <input name='key' type='text'/>
            <input name='salutation' type='text'/>
            <input name='name' type='text'/>
          </form>
          """
      ]
    ]
  ]
