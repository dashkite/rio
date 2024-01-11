import { flow } from "@dashkite/joy/function"
import { pop, read } from "@dashkite/katana"

render = ( template ) -> 
  flow [
    read "handle"
    pop ( handle, data ) ->
      handle.html = template data
  ]

export { render }
