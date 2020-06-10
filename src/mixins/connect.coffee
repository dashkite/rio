import {curry, rtee, pipe} from "@pandastrike/garden"

connect = curry rtee (f, type) ->
  type::connect = -> f [ @ ]


export {connect}
