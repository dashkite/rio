import {read, pop} from "@dashkite/katana"
import {flow} from "@pandastrike/garden"

_disable = (handle) ->
  for el in handle.root.querySelectorAll ":enabled"
    el.disabled = true

disable = flow [
  read "handle"
  pop _disable
]

disable._ = _disable

export {disable}
