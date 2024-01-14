import { pipe } from "@dashkite/joy/function"
import { uncase, camelCase } from "@dashkite/joy/text"
import { poke } from "@dashkite/katana/sync"

isData = ({ name }) -> name.startsWith "data-"

convert = pipe [ uncase, camelCase ]

attributes = poke ( el ) ->
  Object.fromEntries do ->
    # use the data combinator if you want the data attributes
    for attribute in el.attributes when !( isData attribute )
      [
        convert attribute.name
        attribute.value
      ]

export { attributes }
