import * as F from "@dashkite/joy/function"
import * as T from "@dashkite/joy/type"
import { push, test, discard } from "@dashkite/katana/sync"

_within = ( selector ) ->
  ( event, handle ) ->
    event.composedPath()
      .find ( el ) ->
        ( el instanceof Node ) &&
          (handle.root.contains el) &&
          (el.matches? selector)

within = ( selector, fx ) ->
  F.pipe [
    push _within selector
    test T.isDefined, F.pipe fx
    discard
  ]

within._ = _within

export { within }
