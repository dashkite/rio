import {curry} from "@pandastrike/garden"
import {peek} from "@dashkite/katana"

_assign = curry (name, value, handle) -> Object.assign handle[name], value

assign = (name) -> peek _assign name

export {assign, _assign}
