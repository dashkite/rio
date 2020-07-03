import {readonly, readwrite} from "./helpers"

class Handle

  constructor: (@dom) ->

  readonly @::, root: -> @shadow ? @dom
  readwrite @::,
    html:
      get: -> @root.innerHTML
      set: (html) -> @root.innerHTML = html

  on: (name, handler) -> @root.addEventListener name, handler.bind @

  dispatch: (name, detail) ->
    @root.dispatchEvent new CustomEvent name,
      detail: detail ? @
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

export {Handle}
