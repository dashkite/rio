import {curry, pipeWith, rtee} from "@dashkite/joy/function"

mixin = curry (type, mixins) -> ((pipeWith rtee, mixins) type)

export {mixin}
