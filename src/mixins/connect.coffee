import {curry, rtee, pipe} from "@pandastrike/garden"

_connect = curry rtee (f, type) ->
  type::connect = ->
    f [ @ ]
    @root.dispatchEvent new CustomEvent "ready",
      detail: @
      bubbles: false
      cancelable: false
      # don't allow to bubble up from shadow DOM
      composed: false

connect = (fx) -> _connect pipe fx

export {connect, _connect}
