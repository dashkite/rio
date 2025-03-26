import * as K from "@dashkite/katana"
import * as DOM from "@dashkite/dominator"

reflect = K.peek ( attributes, handle ) ->
  DOM.reflect attributes, handle.dom

export { reflect }