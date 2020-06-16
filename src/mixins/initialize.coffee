import {curry, pipe} from "@pandastrike/garden"

_initialize = curry (f, type) ->
  type::initialize = -> f [ @ ]

initialize = (fx) -> _initialize pipe fx

export {initialize, _initialize}
