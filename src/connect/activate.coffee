import {speek, push} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"
import {description} from "../actions/description"

_activate = curry (handler, handle) ->
  _handler = ([..., {intersectionRatio}]) ->
    if intersectionRatio == 1 then handler [ {handle} ]
  observer = new IntersectionObserver _handler, threshold: 1
  observer.observe handle.dom

activate = (fx) -> speek _activate flow fx

activate._ = _activate

export {activate}
