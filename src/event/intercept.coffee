import {flow} from "@pandastrike/garden"
import {prevent} from "./prevent"
import {stop} from "./stop"

intercept = flow [ prevent, stop ]

export {intercept}
