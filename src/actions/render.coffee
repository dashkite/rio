import {peek} from "@dashkite/katana"

render = (template) -> peek (handle) -> handle.html = template handle

export {render}
