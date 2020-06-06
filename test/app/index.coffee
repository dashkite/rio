import {mixin, tag, connect, shadow} from "../../src"

class

  constructor: (@dom) ->

  mixin @, [

    tag "x-greeting"

    connect [
      shadow
    ]

  ]
