import {curry, pipeWith, rtee} from "@pandastrike/garden"

mixin = curry (type, mixins) -> ((pipeWith rtee, mixins) type)

export {mixin}
