import {curry} from "@pandastrike/garden"
import {speek} from "@dashkite/katana"

_sheet = curry (generator, handle) ->
  css = await generator()
  switch css.constructor
    when String
      sheet = new CSSStyleSheet()
      sheet.replaceSync css
    when CSSStyleSheet
      sheet = css
    else
      sheet = new CSSStyleSheet()
      sheet.replaceSync css.toString()
  handle.shadow.adoptedStyleSheets = [ sheet ]

sheet = (generator) -> speek _sheet generator

sheet._ = _sheet

export {sheet}
