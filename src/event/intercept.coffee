import {tee, pipe} from "@pandastrike/garden"
import {prevent} from "./prevent"
import {stop} from "./stop"

intercept = pipe [
  tee prevent
  tee stop
]

export {intercept}
