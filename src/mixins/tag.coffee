import {Method} from "panda-generics"
import {tee} from "panda-garden"
import {properties, isString, isObject} from "panda-parchment"

tag = Method.create()

Method.define tag, isObject, (options) ->

  tee (type) ->

    # TODO: Support customized built-in elements
    # (that's why we have options, but it's unsupported)
    E = class extends HTMLElement
      constructor: ->
        super()
        @gadget = new type @
      connectedCallback: -> @gadget.connect()

    properties type,
      tag: get: -> options.name
      CustomElement: get: -> E

    properties type::, tag: get: -> @constructor.tag

    # allow other mixins to process before registering
    requestAnimationFrame ->
      customElements.define options.name, E

Method.define tag, isString, (name) -> tag {name}

Method.define tag, isString, isObject, (name, options) ->
  options.name = name
  tag options

export {tag}
