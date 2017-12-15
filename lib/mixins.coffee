import {HTML} from "./vhtml"
import {innerHTML} from "diffhtml"
import {isArray, isObject, isFunction,
  properties as _properties} from "fairmont-helpers"
import {Method} from "fairmont-multimethods"

{style, parse} = HTML

properties = (description) ->
  (type) -> _properties type::, description

property = (key, value) ->
  (type) -> _properties type::, "#{key}": description

observe = (description, handler) ->
  for key, value of description
    property key, do (value) ->
      get: -> value
      set: (x) ->
        value = x
        handler.call @, x

composable = observe value: "", -> @target.dispatch "change"

vdom = (type) ->
  properties type::,
    html:
      get: -> @shadow.innerHTML
      set: (html) ->
        vdom = if isString html then (parse html) else html
        vdom.push (style @styles) if @styles
        innerHTML @shadow, value

autorender = (type) ->
  type.events.push change: -> @render()

template = (type) ->
  type::render = -> @html @template @

styles = (type) ->
  properties type::,
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

Method.define mixins, isObject, isFunction, (type, f) -> f type
Method.define mixins, isObject, isArray, (type, mixins) ->
  (mixins type, mixin) for mixin in mixins

export {property, properties, observe,
  composable, vdom, autorender, template, styles,
  # presets
  zen,
  # application
  mixins}
