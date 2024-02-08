import { curry, rtee } from "@dashkite/joy/function"

component = curry rtee ( name, Base, Type ) ->
  Type.Element = class extends Base
    constructor: ->
      super()
      @handle = new Type @
      @handle.initialize?()
    connectedCallback: -> @handle.connect?()
    disconnectedCallback: -> @handle.disconnect?()

tag = curry rtee ( name, Type ) ->
  component name, HTMLElement, Type
  # give the rest of the mixins a chance to load...
  queueMicrotask ->
    customElements.define name, Type.Element

export { component, tag }
