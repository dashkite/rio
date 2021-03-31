import {curry, pipe} from "@dashkite/joy/function"

_disconnect = curry (f, type) ->
  type::disconnect = ->
    f [ @ ]
    @dispatch "ready"

disconnect = (fx) -> _disconnect pipe fx

disconnect._ = _disconnect

export {disconnect}
