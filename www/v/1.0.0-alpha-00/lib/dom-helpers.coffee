$ = (s, d) -> (d ?= document).querySelector s
$.on = (el, events) ->
  for name, handler of events
    el.addEventListener name, handler
$.ready = (fn) -> $.on document, DOMContentLoaded: fn

export default $
