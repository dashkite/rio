import {tee, spread, pipe} from "panda-garden"
import {property, method} from "./helpers"
import {prepare} from "./phased"

root = property
  root:
    get: -> if @shadow? then @shadow else @dom

html = property
  html:
    get: -> @root.innerHTML
    set: (value) -> @root.innerHTML = value

shadow = (spread pipe) [
  prepare -> @dom.attachShadow mode: "open"
  property
    shadow:
      get: -> @dom.shadowRoot
]

render = (template) ->
  method
    render: ->
      # allow for html/template to be async
      await @html = await template @
      @dispatch "render"

export {root, html, shadow, render}
