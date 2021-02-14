import {curry, pipe} from "@pandastrike/garden"
import {read, speek, spush} from "@dashkite/katana"
import {sheets} from "@dashkite/stylist"

_sheet = curry (name, value, handle) ->
  handle.sheets ?= sheets handle.root
  handle.sheets.set name, value

sheet = (name, value) -> speek _sheet name, value

sheet._ = _sheet

export {sheet}
