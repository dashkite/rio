import { curry } from "@dashkite/joy/function"

define = curry ( name, [ base, options ], Type ) ->
  E = class extends base
    constructor: ->
      super()
      @handle = new Type @
      @handle.initialize?()
    connectedCallback: -> @handle.connect?()
    disconnectedCallback: -> @handle.disconnect?()

  # give the rest of the mixins a chance to load...
  queueMicrotask ->
    customElements.define name, E, options

tag = curry ( name, Type ) -> define name, [ HTMLElement ], Type

export { define, tag }
