import {curry, pipe} from "@pandastrike/garden"

mixin = curry (type, mixins) -> ((pipe mixins) type)

export * from "./tag"
export * from "./diff"
export * from "./connect"
export {mixin}
