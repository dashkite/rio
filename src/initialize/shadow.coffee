import {peek} from "@dashkite/katana/sync"
import {readonly} from "../helpers"

_shadow = (handle) ->
  handle.dom.attachShadow mode: "open"
  readonly handle, shadow: -> @dom.shadowRoot

shadow = peek _shadow

shadow._ = _shadow

export {shadow}
