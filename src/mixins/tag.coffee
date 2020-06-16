import {curry} from "@pandastrike/garden"

tag = curry (name, type) ->

  E = class extends HTMLElement
    constructor: ->
      super()
      @handle = new type @
      @handle.initialize?()
    connectedCallback: -> @handle.connect?()

  customElements.define name, E

export {tag}
