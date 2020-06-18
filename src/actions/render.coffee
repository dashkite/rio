import {curry, flow} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

_render = curry (template, handle) -> handle.html = template handle

render = (template) -> flow [
  read "handle"
  pop _render template
]

export {render, _render}
