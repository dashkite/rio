import {Handle, mixin, tag, diff, connect, shadow} from "../../src"

class extends Handle

  mixin @, [
    tag "x-greeting"
    diff
    connect [
      shadow
    ]

  ]
