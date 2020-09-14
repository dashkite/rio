import {speek, push} from "@dashkite/katana"
import {curry, flow} from "@pandastrike/garden"
import {description} from "../actions/description"

_deactivate = curry (handler, handle) ->
  _handler = ([..., {intersectionRatio}]) ->
    if intersectionRatio <= 0 then handler [ {handle} ]
  observer = new IntersectionObserver _handler, threshold: 0
  observer.observe handle.dom

deactivate = (fx) -> speek _deactivate flow fx

deactivate._ = _deactivate

export {deactivate}
