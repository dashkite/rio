import {readonly} from "../helpers"

shadow = (gadget) ->
  gadget.dom.attachShadow mode: "open"
  readonly gadget, shadow: -> @dom.shadowRoot

export {shadow}
