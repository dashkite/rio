import {pipe} from "@dashkite/joy/function"
import { replace, uncase, camelCase } from "@dashkite/joy/text"
import {poke, read} from "@dashkite/katana/sync"

# TODO this  should be in joy
fromEntries = (pairs) -> Object.fromEntries pairs
# TODO should we exclude data properties?
convert = pipe [ uncase, camelCase ]

_attributes = (handle) ->
  fromEntries ([ (convert a.name), a.value ] for a in handle.dom.attributes)

attributes = pipe [
  read "handle"
  poke _attributes
]

attributes._ = _attributes

export {attributes}
