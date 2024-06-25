import * as k from "@dashkite/katana/sync"

target = k.poke ( event ) -> event._target ? event.target

export { target }
