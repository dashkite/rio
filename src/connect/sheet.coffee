import {curry, once} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

create = (generator) ->
  ->
    console.log "generating CSS"
    s = new CSSStyleSheet()
    s.replaceSync generator()
    s

_sheet = curry (generator, handle) ->
  f = once create generator
  handle.shadow.adoptedStyleSheets = [ f() ]

sheet = (generator) -> speek _sheet generator

export {sheet, _sheet}
