import {curry, rtee, pipe} from "@pandastrike/garden"

bind = (f) -> (ax...) -> f.apply @, ax

connect = curry rtee (graph, type) ->
  f = pipe graph
  type::connect = -> f [ @ ]

export {connect}
