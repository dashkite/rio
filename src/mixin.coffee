import {curry, pipe} from "@pandastrike/garden"

mixin = curry (type, mixins) -> ((pipe mixins) type)

export {mixin}
