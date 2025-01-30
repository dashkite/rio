import * as Fn from "@dashkite/joy"
import * as K from "@dashkite/katana/sync"

dataset = Fn.pipe [
  K.read "handle"
  K.poke ( handle ) -> { handle.dom.dataset... }
]

export { dataset }
