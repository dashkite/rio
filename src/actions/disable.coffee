import {read, pop} from "@dashkite/katana"
import {flow} from "@pandastrike/garden"

_enable = (handle) ->
  for el in handle.root.querySelectorAll ":disabled"
    el.disabled = false

enable = flow [
  read "handle"
  pop _enable
]

_disable = (handle) ->
  for el in handle.root.querySelectorAll ":enabled"
    el.disabled = true

disable = flow [
  read "handle"
  pop _disable
]

enable._ = _enable
disable._ = _disable

export {enable, disable}
