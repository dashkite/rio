import {curry} from "@pandastrike/garden"
import {peek} from "@dashkite/katana"

_render = curry (template, handle) -> handle.html = template handle

render = (template) -> peek _render template

export {render, _render}
