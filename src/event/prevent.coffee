import { pipe } from "@dashkite/joy/function"
import { read, pop } from "@dashkite/katana/sync"

_prevent = ( event ) -> event.preventDefault()

prevent = pipe [
  read "event"
  pop _prevent
]

prevent._ = _prevent

export { prevent }
