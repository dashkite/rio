import * as K from "@dashkite/katana/sync"
import * as Fn from "@dashkite/joy/function"
import * as DOM from "@dashkite/dominator"

_modify = ( attributes, handler ) ->
  ( handle ) ->
    do ->
      for await event from DOM.modify attributes, handle.dom
        handler { handle }
    # avoid returning promise
    undefined    

modify = ( attributes, fx ) ->
  K.peek _modify attributes, Fn.pipe [
    K.read "handle"
    K.push ( handle ) -> handle.dom
    fx...
  ]

export { modify }
