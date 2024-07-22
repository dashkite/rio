import { peek } from "@dashkite/katana/sync"
import { read } from "@dashkite/katana/async"
import { curry, flow } from "@dashkite/joy/function"

deactivate = ( fx ) ->
  handler = flow [ ( read "handle" ), fx ]
  peek ( handle ) ->
    _handler = ([..., { intersectionRatio }]) ->
      if intersectionRatio <= 0 then handler { handle }
    observer = new IntersectionObserver _handler, threshold: 0
    observer.observe handle.dom

export { deactivate }
