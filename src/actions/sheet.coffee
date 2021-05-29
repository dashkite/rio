import {curry, pipe} from "@dashkite/joy/function"
import {read, pop} from "@dashkite/katana/sync"
import {sheets} from "@dashkite/stylist"

_sheet = curry (dictionary, handle) ->
  handle.sheets ?= sheets handle.root
  # TODO this should be added as an interface to Stylist
  for name, value of dictionary
    handle.sheets.set name, value

sheet = (dictionary) -> pipe [
  read "handle"
  pop _sheet dictionary
]

sheet._ = _sheet

export {sheet}
