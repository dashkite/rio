import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"

_navigate = curry ( handler, handle ) ->
  window.addEventListener "popstate", -> handler { handle }

navigate = ( fx ) -> peek _navigate flow fx

navigate._ = _navigate

export { navigate }
