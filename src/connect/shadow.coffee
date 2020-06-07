import {readonly} from "../helpers"

shadow = ([handle]) ->
  handle.dom.attachShadow mode: "open"
  readonly handle, shadow: -> @dom.shadowRoot

export {shadow}
