import {curry, pipe} from "@pandastrike/garden"

_disconnect = curry (f, type) ->
  type::disconnect = ->
    f [ @ ]
    @dispatch "ready"

disconnect = (fx) -> _disconnect pipe fx

disconnect._ = _disconnect

export {disconnect}
