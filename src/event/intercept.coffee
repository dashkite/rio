import {tee, pipe} from "@pandastrike/garden"
import {spop} from "@dashkite/katana"
import {prevent} from "./prevent"
import {stop} from "./stop"

_intercept = pipe [
  tee prevent
  tee stop
]

intercept = spop _intercept

export {intercept, _intercept}
