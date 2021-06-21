import {pipe} from "@dashkite/joy/function"
import {read, pop} from "@dashkite/katana/sync"

_stop = (event) -> event.stopPropagation()

stop = pipe [
  read "event"
  pop _stop
]

stop._ = _stop

export {stop}
