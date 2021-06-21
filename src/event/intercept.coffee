import {pipe} from "@dashkite/joy/function"
import {read, peek, pop} from "@dashkite/katana/sync"
import {prevent} from "./prevent"
import {stop} from "./stop"

intercept = pipe [
  prevent
  stop
]

export {intercept}
