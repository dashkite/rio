import {curry, rtee, pipe} from "@pandastrike/garden"

_initialize = curry rtee (f, type) ->
  type::initialize = -> f [ @ ]

initialize = (fx) -> _initialize pipe fx

export {initialize, _initialize}
