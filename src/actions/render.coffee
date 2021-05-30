import {curry, flow} from "@dashkite/joy/function"
import {pop, read} from "@dashkite/katana"

_render = (template) -> (handle, data) -> handle.html = template data

render = (template) -> flow [
  read "handle"
  pop _render template
]

render._ = _render

export {render}
