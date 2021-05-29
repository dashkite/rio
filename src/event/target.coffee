import {curry} from "@dashkite/joy/function"
import * as k from "@dashkite/katana/sync"

# TODO we may want to explore alternative implementations or even
#      additional combinators that use the composedPath method to
#      allow us to handle events originating from slotted DOM

_target = curry (event, {handle}) -> event._target ? event.target

target = k.push _target

target._ = _target

export {target}
