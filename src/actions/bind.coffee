import {arity} from "@pandastrike/garden"

bind = (f) -> arity (f.length + 1), (ax..., handle) -> f.apply handle, ax

export {bind}
