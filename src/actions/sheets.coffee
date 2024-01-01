import {curry, pipe} from "@dashkite/joy/function"
import {read, pop} from "@dashkite/katana/sync"
import * as Stylist from "@dashkite/stylist"

sheets = ( list ) ->
  pipe [
    read "handle"
    pop ( handle ) ->
      Stylist.sheets handle.root, list
  ]

export { sheets }
