import {pipe} from "@dashkite/joy/function"
import {poke, read} from "@dashkite/katana/sync"

_description = (handle) -> { handle.dom.dataset... }

description = pipe [
  read "handle"
  poke _description
]

description._ = _description

export {description}
