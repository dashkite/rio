import * as Fn from "@dashkite/joy/function"

debounce = ( delay, fx ) ->
  f = Fn.flow fx
  do ({ last } = {}) ->
    last = 0
    ( daisho ) ->
      now = do performance.now
      elapsed = now - last
      if elapsed > delay
        last = now
        f daisho

export { debounce }