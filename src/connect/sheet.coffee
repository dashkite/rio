import {curry, pipe} from "@pandastrike/garden"
import {read, speek, spush} from "@dashkite/katana"

_generate = (css) ->
  # can't use constructor check because of polyfill
  if css instanceof CSSStyleSheet
    css
  else if css.apply?
    _generate css()
  else
    r = new CSSStyleSheet()
    r.replaceSync css.toString()
    r

_sheet = curry (value, handle) ->
  handle.root.adoptedStyleSheets = [ _generate value ]

sheet = (value) -> speek _sheet value

sheet._ = _sheet

export {sheet}
