import {peek} from "@dashkite/katana"
import {getter} from "../helpers"

shadow = peek (gadget) ->
  gadget.dom.attachShadow mode: "open"
  getter gadget, shadow: -> @dom.shadowRoot

export {shadow}
