import {properties as $P, methods as $M} from "panda-parchment"
import {pipe, tee} from "panda-garden"

property = properties = (description) -> tee (type) -> $P type::, description
$property = $properties = (description) -> tee (type) -> $P type, description
method = methods = (description) -> tee (type) -> $M type::, description
$method = $methods = (description) -> tee (type) -> $M type, description
assign = (description) -> tee (type) -> Object.assign type::, description
$assign = (description) -> tee (type) -> Object.assign type, description

root = property root: get: -> if @shadow? then @shadow else @dom

html = property
  html:
    get: -> @root.innerHTML
    set: (value) -> @root.innerHTML = value

# TODO: prepare mixin?
shadow = tee (type) ->
  type.prepare -> @dom.attachShadow mode: "open"
  $P type::, shadow: get: -> @dom.shadowRoot

render = (template) ->
  method
    render: ->
      @html = await template @
      @dispatch "render"

autorender = tee (type) ->
  type.on change: -> @render()
  type.ready -> @render()

mixin = (type, mixins) -> _mixin type for _mixin in mixins

export {property, properties, $property, $properties,
  method, methods, $method, $methods, assign, $assign,
  root, html, shadow, render, autorender, mixin}
