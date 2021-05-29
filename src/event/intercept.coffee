import {tee, pipe} from "@dashkite/joy/function"
import {pop} from "@dashkite/katana/sync"
import {prevent} from "./prevent"
import {stop} from "./stop"

_intercept = pipe [
  tee prevent
  tee stop
]

intercept = pop _intercept

intercept._ = _intercept

export {intercept}
