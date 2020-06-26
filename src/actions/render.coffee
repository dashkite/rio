import {curry, flow} from "@pandastrike/garden"
import {pop, read} from "@dashkite/katana"

_render = curry (template, handle, data) -> handle.html = template data

render = (template) -> flow [
  read "handle"
  pop _render template
]

render._ = _render

export {render}
