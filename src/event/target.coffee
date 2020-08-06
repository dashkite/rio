import {curry} from "@pandastrike/garden"
import * as k from "@dashkite/katana"

# TODO we may want to explore alternative implementations or even
#      additional combinators that use the composedPath method to
#      allow us to handle events originating from slotted DOM

_target = curry (event, {handle}) -> event._target ? event.target

target = k.spush _target

target._ = _target

export {target}
