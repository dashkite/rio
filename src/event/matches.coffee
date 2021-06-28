import {curry, binary, pipe} from "@dashkite/joy/function"
import {generic} from "@dashkite/joy/generic"
import {isString} from "@dashkite/joy/type"
import {test} from "@dashkite/katana/sync"

isEvent = (x) -> x instanceof Event
isNode = (x) -> x instanceof Node

_matches = generic
  name: "_matches"
  default: -> false
  
generic _matches, isString, isEvent, (selector, event) ->
  _matches selector, event.target

generic _matches, isString, isNode, (selector, el) ->
  el.matches selector

_matches = curry binary _matches

matches = (selector, fx) -> test (_matches selector), pipe fx

matches._ = _matches

export {matches}
