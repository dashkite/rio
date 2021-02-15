import {read, spop} from "@dashkite/katana"
import {pipe} from "@pandastrike/garden"

_enable = (handle) ->
  for el in handle.root.querySelectorAll ":disabled"
    el.disabled = false

enable = pipe [
  read "handle"
  spop _enable
]

_disable = (handle) ->
  for el in handle.root.querySelectorAll ":enabled"
    el.disabled = true

disable = pipe [
  read "handle"
  spop _disable
]

enable._ = _enable
disable._ = _disable

export {enable, disable}
