import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isString, isArray, isKind, isFunction,
  properties as _properties} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"

{style, parse} = HTML

properties = (description) ->
  (type) -> _properties type::, description

property = (key, value) ->
  (type) -> _properties type::, "#{key}": value

observe = (description, handler) ->
  for key, value of description
    property key, do (value) ->
      get: -> value
      set: (x) ->
        value = x
        handler.call @, value

composable = [
  observe value: "", -> @dispatch "change"
  (source) ->
    source::pipe = (target) ->
      @on change: -> target.value = @value
]

vdom = properties
  html:
    get: -> @shadow.innerHTML
    set: (html) ->
      vdom = if (isString html) then (parse html) else html
      vdom.push (style @styles)
      innerHTML @shadow, vdom

autorender = (type) ->
  type.on change: -> @render()
  type::ready = -> @render()

template = (type) ->
  type::render = -> @html = @constructor.template @

styles = properties
  styles:
    get: ->
      styles = ""
      re = ///#{@tag}\s+:host\s+///g
      for sheet in document.styleSheets when sheet.rules?
        for rule in sheet.rules when (rule.cssText.match re)
          styles += (rule.cssText.replace re, "") + "\n"
      styles

zen = [ composable, vdom, autorender, styles, template ]

mixins = Method.create default: -> new TypeError "mixins: bad argument"

Method.define mixins, (isKind Object), isFunction, (type, f) -> f type

Method.define mixins, (isKind Object), isArray, (type, list) ->
  (mixins type, mixin) for mixin in list

export {property, properties, observe,
  composable, vdom, autorender, template, styles,
  # presets
  zen,
  # application
  mixins}
