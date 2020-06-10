import {speek} from "@dashkite/katana"
import {readonly} from "../helpers"

_shadow = (handle) ->
  handle.dom.attachShadow mode: "open"
  readonly handle, shadow: -> @dom.shadowRoot

shadow = speek _shadow

export {shadow, _shadow}
