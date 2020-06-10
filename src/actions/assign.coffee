import {curry} from "@pandastrike/garden"

assign = curry (name, value, handle) -> Object.assign handle[name], value

export {assign}
