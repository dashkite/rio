import {curry} from "@pandastrike/garden"

render = curry (template, handle) -> handle.html = template handle

export {render}
