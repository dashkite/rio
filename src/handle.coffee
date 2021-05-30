import {mixin, getter, property} from "@dashkite/joy/metaclass"

class Handle

  constructor: (@dom) ->

  mixin @::, [
    getter "root", -> @shadow ? @dom
    property "html",
      get: -> @root.innerHTML
      set: (html) -> @root.innerHTML = html
  ]

  on: (name, handler) -> @root.addEventListener name, handler.bind @

  dispatch: (name, detail) ->
    @root.dispatchEvent new CustomEvent name,
      detail: detail ? @
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

export { Handle }
