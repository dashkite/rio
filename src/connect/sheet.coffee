import {curry, once} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

create = (generator) ->
  ->
    s = new CSSStyleSheet()
    s.replaceSync generator()
    s

_sheet = curry (generator, handle) ->
  handle.constructor.stylesheet ?= do once create generator
  handle.shadow.adoptedStyleSheets = [ handle.constructor.stylesheet ]

sheet = (generator) -> speek _sheet generator

sheet._ = _sheet

export {sheet}
