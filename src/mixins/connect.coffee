import {curry, pipe} from "@pandastrike/garden"

_connect = curry (f, type) ->
  type::connect = ->
    f [ @ ]
    @dispatch "ready"

connect = (fx) -> _connect pipe fx

connect._ = _connect

export {connect}
