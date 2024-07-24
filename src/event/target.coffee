import * as k from "@dashkite/katana/sync"

target = k.push ( event ) -> event._target ? event.target

export { target }
