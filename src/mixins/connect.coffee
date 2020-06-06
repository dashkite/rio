import {curry, rtee, pipe} from "@pandastrike/garden"

connect = curry rtee (graph, type) ->
  f = pipe graph
  type::connect = -> f [ @ ]

export {connect}
