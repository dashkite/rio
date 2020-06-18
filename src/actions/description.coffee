import {flow} from "@pandastrike/garden"
import {poke, read} from "@dashkite/katana"

_description = (handle) -> Object.assign {}, handle.dom.dataset

description = flow [
  read "handle"
  poke _description
]

export {description, _description}
