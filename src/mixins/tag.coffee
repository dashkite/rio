import {rtee, curry} from "@pandastrike/garden"

tag = curry rtee (name, type) ->

  E = class extends HTMLElement
    constructor: ->
      super()
      @handle = new type @
      @handle.initialize?()
    connectedCallback: -> @handle.connect?()

  # allow other mixins to process before registering
  requestAnimationFrame -> customElements.define name, E

export {tag}
