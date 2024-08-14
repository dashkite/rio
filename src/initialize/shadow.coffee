import { peek } from "@dashkite/katana/sync"
import { mixin, getter } from "@dashkite/joy/metaclass"

shadow = peek ( handle ) ->
  handle.dom.attachShadow mode: "open", delegatesFocus: true
  mixin handle, [ getter "shadow", -> @dom.shadowRoot ]

export { shadow }
