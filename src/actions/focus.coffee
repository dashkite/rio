import * as F from "@dashkite/joy/function"
import * as K from "@dashkite/katana"

_focus = (handle) -> (handle.root.querySelector selector)?.focus()

focus = (selector) ->
  F.flow [
    K.read "handle"
    K.pop _focus
  ]

focus._ = _focus

export { focus }
