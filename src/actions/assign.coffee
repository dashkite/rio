import { mpop } from "@dashkite/katana/sync"

assign = ( name ) ->
  mpop ( source, target ) ->
    Object.assign target, source

export { assign }
