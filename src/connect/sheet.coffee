import {curry, once} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

create = (generator) ->
  ->
    s = new CSSStyleSheet()
    s.replaceSync generator()
    s

_sheet = curry (generator, handle) ->
  handle.constructor._stylesheet ?= do once create generator
  handle.shadow.adoptedStyleSheets = [ handle.constructor._stylesheet ]

sheet = (generator) -> speek _sheet generator

export {sheet, _sheet}
