import { peek } from "@dashkite/katana/sync"

set = ( name ) ->
  peek ( value, object ) -> object[ name ] = value

export { set }
