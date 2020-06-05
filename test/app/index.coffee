import {mixin, tag, connect} from "../../src"

class

  mixin @, [

    tag "x-greeting"

    connect [
      ([gadget])-> gadget.test = "Hello, world!"
    ]

  ]
