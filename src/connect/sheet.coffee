import {curry, pipe} from "@pandastrike/garden"
import {read, speek, spush} from "@dashkite/katana"

_bind = curry (css) ->
  if css.constructor == CSSStyleSheet
    css
  else if css.apply?
    _bind css()
  else
    r = new CSSStyleSheet()
    r.replaceSync css.toString()
    r

_sheet = curry (value, handle) ->
  handle.root.adoptedStyleSheets = [ _bind value ]

sheet = (value) -> speek _sheet value

sheet._ = _sheet

export {sheet}
