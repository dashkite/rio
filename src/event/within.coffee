import * as F from "@dashkite/joy/function"
import * as T from "@dashkite/joy/type"
import {push, test} from "@dashkite/katana/sync"

_within = (selector) -> (event, handle) ->
  if (target = (event?.target?.closest? selector))?
    if handle.root.contains target
      target

within = (selector, fx) ->
  F.pipe [
    push _within selector
    test T.isDefined, F.pipe fx
  ]

within._ = _within

export {within}
