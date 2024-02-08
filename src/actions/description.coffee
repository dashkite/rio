import { pipe } from "@dashkite/joy/function"
import { poke, read } from "@dashkite/katana/sync"

description = pipe [
  read "handle"
  poke ( handle ) -> { handle.dom.dataset... }
]

export { description }
