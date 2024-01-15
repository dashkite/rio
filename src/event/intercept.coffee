import { pipe } from "@dashkite/joy/function"
import { prevent } from "./prevent"
import { stop } from "./stop"

intercept = pipe [
  prevent
  stop
]

export { intercept }
