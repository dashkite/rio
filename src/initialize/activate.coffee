import { read } from "@dashkite/katana/async"
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

intersects = ( event ) -> event.isIntersecting

activate = ( fx ) ->
  f = flow [( read "handle"), fx... ]
  peek ( handle ) ->
    handler = debounce tolerance, -> f { handle }
    observer = new IntersectionObserver ( events ) ->
      do handler if ( events.find intersects )?        
    observer.observe handle.dom

export { activate }
