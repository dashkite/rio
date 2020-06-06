import {peek} from "@dashkite/katana"
import {readonly} from "../helpers"

shadow = peek (gadget) ->
  gadget.dom.attachShadow mode: "open"
  readonly gadget, shadow: -> @dom.shadowRoot

export {shadow}
