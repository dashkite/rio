import * as Fn from "@dashkite/joy/function"
import * as Meta from "@dashkite/joy/metaclass"
import * as Ks from "@dashkite/katana/sync"
import * as K from "@dashkite/katana/async"

import { initialize } from "./initialize"
import { keyup } from "../initialize/input"

# TODO hard-coded for input element

properties = Meta.properties 
  value:
    get: -> ( @shadowRoot.querySelector "input" )?.value
    set: ( value ) ->
      ( @shadowRoot.querySelector "input" )?.value = value
      @handle.internals.setFormValue value
  form:
    get: -> @handle.internals.form
  name:
    get: -> @getAttribute "name"
  type:
    get: -> @localName
  validity:
    get: -> @handle.internals.validity
  validationMessage:
    get: -> @handle.internals.validationMessage
  willValidate:
    get: -> @handle.internals.willValidate

methods = Meta.methods
  checkValidity: -> do @handle.internals.checkValidity
  reportValidity: -> do @handle.internals.reportValidity

field = Fn.pipe [

  Fn.tee ( Type ) -> 
    Type.Element.formAssociated = true
    properties Type.Element::
    methods Type.Element::

  initialize [

    Ks.peek ( handle ) ->
      handle.internals = handle.dom.attachInternals()

    keyup "input", [
      K.peek ( event, handle ) ->
        handle.internals.setFormValue event.target.value
    ]

  ]
]

export { field }
