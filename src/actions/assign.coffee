import { mpop } from "@dashkite/katana/sync"

assign = mpop ( source, target ) ->
  Object.assign target, source

export { assign }
