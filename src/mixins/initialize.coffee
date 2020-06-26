import {curry, pipe} from "@pandastrike/garden"

_initialize = curry (f, type) ->
  type::initialize = -> f [ @ ]

initialize = (fx) -> _initialize pipe fx

initialize._ = _initialize

export {initialize}
