import {curry, pipe} from "@pandastrike/garden"

mixin = curry (type, mixins) -> ((pipe mixins) type)

export * from "./tag"
export * from "./connect"
export {mixin}
