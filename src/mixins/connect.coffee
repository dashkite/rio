import {curry, rtee, flow} from "@pandastrike/garden"

bind = (f) -> (ax...) -> f.apply @, ax

connect = curry rtee (graph, type) ->
  f = flow graph

  type::connect = -> f [ @ ]

export {connect}
