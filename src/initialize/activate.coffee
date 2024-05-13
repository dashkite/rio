import { Daisho } from "@dashkite/katana"
import { peek } from "@dashkite/katana/sync"
import { curry, flow } from "@dashkite/joy/function"

tolerance = 500 #ms

debounce = ( ms, f ) ->
  # ensure the first time always fires
  do ( last = -ms ) ->
    ( args... ) ->
      current = performance.now()
      if ms <= ( current - last )
        last = current
        f args...

_activate = curry ( handler, handle ) ->
  _handler = debounce tolerance, ->
    handler Daisho.create { handle }
  _callback = ( events ) ->
    for event in events  
      if event.isIntersecting
        do _handler
        return
  observer = new IntersectionObserver _callback
  observer.observe handle.dom

activate = ( fx ) -> peek _activate flow fx

export { activate }
