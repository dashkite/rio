import { flow } from "@dashkite/joy/function"
import { pop, read } from "@dashkite/katana"

render = ( template ) -> 
  flow [
    read "handle"
    pop ( handle, data ) ->
      result = template data
      if result.then?
        result.then ( html ) -> handle.html = html
      else
        handle.html = result
  ]

export { render }
