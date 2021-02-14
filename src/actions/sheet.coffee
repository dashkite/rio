import {curry, pipe} from "@pandastrike/garden"
import {read, speek, spush} from "@dashkite/katana"
import {sheets} from "@dashkite/stylist"

_sheet = curry (dictionary, handle) ->
  handle.sheets ?= sheets handle.root
  # TODO this should be added as an interface to Stylist
  for name, value of dictionary
    handle.sheets.set name, value

sheet = (dictionary, value) -> speek _sheet dictionary, value

sheet._ = _sheet

export {sheet}
