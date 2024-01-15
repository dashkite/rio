import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"

tolerance = 500 #ms

debounce = ( ms, f ) ->
  do ( last = 0 ) ->
    ( args... ) ->
      current = performance.now()
      if current > ( last + ms )
        last = current
        f args...

_activate = curry ( handler, handle ) ->
  _handler = debounce tolerance, ([..., { intersectionRatio }]) ->
    if intersectionRatio > 0 then handler { handle }
  observer = new IntersectionObserver _handler, threshold: 0
  observer.observe handle.dom

activate = ( fx ) -> peek _activate flow fx

activate._ = _activate

export { activate }
