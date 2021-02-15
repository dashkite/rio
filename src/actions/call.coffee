import {arity, flow} from "@pandastrike/garden"
import {poke, read} from "@dashkite/katana"

_call = (f) -> arity (f.length + 1), (handle, ax...) -> f.apply handle, ax

call = (f) -> flow [
  read "handle"
  poke _call f
]

call._ = _call

export {call}
