import {identity} from "panda-garden"
import {isString, isArray, isKind, isPromise} from "panda-parchment"
import Method from "panda-generics"

class Gadget

  # definitions below
  @query: Method.create
    name: "query"
    description: "provides document.querySelector interface for gadget"

  # definitions below
  @queryAll: Method.create
    name: "queryAll"
    description: "provides document.querySelectorAll interface for gadget"

  constructor: (@dom) ->

isQueryable = (value) -> value?.querySelectorAll?
isHTMLElement = isKind HTMLElement
isGadget = isKind Gadget

$ = Gadget.query

Method.define $, isGadget, identity

Method.define $, isPromise, identity

Method.define $, isHTMLElement, (element) ->
  tag = element.tagName.toLowerCase()
  await customElements.whenDefined tag
  await element.gadget.ready
  element.gadget

Method.define $, isString, isQueryable, (selector, dom) ->
  ($ element) if (element = dom.querySelector selector)?

Method.define $, isString, (selector) -> $ selector, document

$$ = Gadget.queryAll

Method.define $$, isArray, (nodes) -> $ node for node in nodes

Method.define $$, isString, isQueryable, (selector, dom) ->
  $$ Array.from dom.querySelectorAll selector

Method.define $$, isString, (selector) ->
  $$ selector, document

export {Gadget, $, $$}
