import {pipe} from "@pandastrike/garden"
import {prevent} from "./prevent"
import {stop} from "./stop"

intercept = pipe [ prevent, stop ]

export {intercept}
