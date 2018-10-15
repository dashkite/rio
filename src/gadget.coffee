import {identity} from "panda-garden"
import {isString, isArray, isKind, isPromise} from "panda-parchment"
import {Method} from "panda-generics"
import {helpers} from "./mixins"

class Gadget

  @define: (description) ->
    type = class extends @
    for key, value of description
      if helpers[key]?
        helpers[key] type, value
      else
        type[key] = value

  # definitions below
  @query: Method.create
    default: (args...) ->
      console.error args...
      throw "Gadget.query: bad arguments"

  # definitions below
  @queryAll: Method.create
    default: (args...) ->
      console.error args...
      throw "Gadget.queryAll: bad arguments"

  constructor: (@dom) ->

gadget = (description) -> Gadget.define description

isQueryable = (value) -> value?.querySelectorAll?
isHTMLElement = isKind HTMLElement
isGadget = isKind Gadget

$ = Gadget.query

Method.define $, isGadget, identity

Method.define $, isPromise, identity

Method.define $, isHTMLElement, (element) ->
  _tag = element.tagName.toLowerCase()
  await customElements.whenDefined _tag
  await element.gadget.isReady
  element.gadget

Method.define $, isString, isQueryable, (selector, dom) ->
  $ dom.querySelector selector

Method.define $, isString, (selector) -> $ selector, document

$$ = Gadget.queryAll

Method.define $$, isArray, (nodes) -> $ node for node in nodes

Method.define $$, isString, isQueryable, (selector, dom) ->
  $$ Array.from dom.querySelectorAll selector

Method.define $$, isString, (selector) ->
  $$ selector, document

export {Gadget, gadget, $, $$}
