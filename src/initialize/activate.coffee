import {peek} from "@dashkite/katana/sync"
import {curry, flow} from "@dashkite/joy/function"

_activate = curry (handler, handle) ->
  _handler = ([..., {intersectionRatio}]) ->
    if intersectionRatio > 0 then handler { handle }
  observer = new IntersectionObserver _handler, threshold: 0
  observer.observe handle.dom

activate = (fx) -> peek _activate flow fx

activate._ = _activate

export {activate}
