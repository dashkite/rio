import { pipe } from "@dashkite/joy/function"
import { peek } from "@dashkite/katana/sync"
import * as Stylist from "@dashkite/stylist"

sheets = ( list ) ->
  peek ( handle ) ->
    Stylist.sheets handle.root, list
    # stylist returns a promise, but we don't want to wait on it
    return

export { sheets }
