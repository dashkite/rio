import {arity} from "@pandastrike/garden"
import {peek} from "@dashkite/katana"

bind = (f) -> peek arity f.length, (ax..., handle) -> f.apply handle, ax

export {bind}
