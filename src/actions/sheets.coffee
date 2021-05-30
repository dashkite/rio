import {curry, pipe} from "@dashkite/joy/function"
import {read, pop} from "@dashkite/katana/sync"
import * as Stylist from "@dashkite/stylist"

_sheets = curry (dictionary, handle) ->
  handle.sheets ?= Stylist.sheets handle.root
  # TODO this should be added as an interface to Stylist
  for name, value of dictionary
    handle.sheets.set name, value

sheets = (dictionary) ->
  pipe [
    read "handle"
    pop _sheets dictionary
  ]

sheets._ = _sheets

export {sheets}
