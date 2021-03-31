import {speek} from "@dashkite/katana"
import {curry, flow} from "@dashkite/joy/function"

_navigate = curry (handler, handle) ->
  window.addEventListener "popstate", -> handler [ {handle} ]

navigate = (fx) -> speek _navigate flow fx

navigate._ = _navigate

export {navigate}
