import {curry} from "@pandastrike/garden"

define = curry (name, [ base, options ], type) ->
  E = class extends base
    constructor: ->
      super()
      @handle = new type @
      @handle.initialize?()
    connectedCallback: -> @handle.connect?()
    disconnectedCallback: -> @handle.disconnect?()

  customElements.define name, E, options

tag = curry (name, type) -> define name, [ HTMLElement ], type

export {define, tag}
