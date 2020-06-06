import {curry, rtee, pipe} from "@pandastrike/garden"

connect = curry rtee (graph, type) ->
  type::connect = -> (f @) for f in graph


export {connect}
