import { read, pop } from "@dashkite/katana/sync"
import { pipe } from "@dashkite/joy/function"

_enable = ( handle ) ->
  for el in handle.root.querySelectorAll ":disabled"
    el.disabled = false

enable = pipe [
  read "handle"
  pop _enable
]

_disable = ( handle ) ->
  for el in handle.root.querySelectorAll ":enabled"
    el.disabled = true

disable = pipe [
  read "handle"
  pop _disable
]

enable._ = _enable
disable._ = _disable

export { enable, disable }
