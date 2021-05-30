import {curry, pipe} from "@dashkite/joy/function"

_connect = curry (f, type) ->
  type::connect = ->
    f [ @ ], handle: @
    @dispatch "ready"

connect = (fx) -> _connect pipe fx

connect._ = _connect

export {connect}
