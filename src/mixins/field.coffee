import * as Fn from "@dashkite/joy/function"
import * as Meta from "@dashkite/joy/metaclass"
import * as Ks from "@dashkite/katana/sync"

import { initialize } from "./initialize"

field = do ->

  properties = Meta.properties 
    value:
      get: -> @_value
      set: ( value ) ->
        @_value = value
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
    setValidity: ( args...) -> @handle.internals.setValidity args...
    checkValidity: -> do @handle.internals.checkValidity
    reportValidity: -> do @handle.internals.reportValidity

  Fn.pipe [

    Fn.tee ( Type ) -> 
      Type.Element.formAssociated = true
      properties Type.Element::
      methods Type.Element::

    initialize [

      Ks.peek ( handle ) ->
        handle.internals = handle.dom.attachInternals()

    ]
  ]

export { field }
