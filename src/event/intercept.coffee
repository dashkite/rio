import {tee, pipe} from "@dashkite/joy/function"
import {spop} from "@dashkite/katana"
import {prevent} from "./prevent"
import {stop} from "./stop"

_intercept = pipe [
  tee prevent
  tee stop
]

intercept = spop _intercept

intercept._ = _intercept

export {intercept}
