import { pipe } from "@dashkite/joy/function"
import { read } from "@dashkite/katana/sync"
import { data } from "./data"

description = pipe [
  read "handle"
  data
]

export { description }
