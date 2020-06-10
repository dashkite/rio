import {arity} from "@pandastrike/garden"
import {peek} from "@dashkite/katana"

_bind = (f) -> arity (f.length + 1), (ax..., handle) -> f.apply handle, ax

bind = (f) -> peek _bind f

export {bind, _bind}
