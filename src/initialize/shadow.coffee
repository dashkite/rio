import {peek} from "@dashkite/katana/sync"
import {mixin, getter} from "@dashkite/joy/metaclass"

_shadow = (handle) ->
  handle.dom.attachShadow mode: "open"
  mixin handle, [ getter "shadow", -> @dom.shadowRoot ]

shadow = peek _shadow

shadow._ = _shadow

export {shadow}
