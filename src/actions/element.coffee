import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

Run =
  nullary: ( method ) ->
    K.peek ( el ) -> el?[ method ]?()
  
  unary: ( method, argument ) ->
    K.peek ( el, argument ) -> el?[ method ]? argument

  # ...

blur = Run.nullary "blur"

export { blur }
