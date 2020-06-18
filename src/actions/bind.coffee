import {arity, flow} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

_bind = (f) -> arity (f.length + 1), (handle, ax...) -> f.apply handle, ax

bind = (f) -> flow [
  read "handle"
  pop _bind f
]

export {bind, _bind}
