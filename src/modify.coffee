import * as K from "@dashkite/katana/sync"
import * as Fn from "@dashkite/joy/function"
import DOM from "@dashkite/dominator"

_modify = ( attributes, handler ) ->
  ( handle ) ->
    do ->
      for await event from DOM.modify attributes, handle.dom
        handler { handle }
    # avoid returning promise
    undefined    

modify = ( attributes, fx ) ->
  K.peek _modify attributes, Fn.flow fx

export { modify }
