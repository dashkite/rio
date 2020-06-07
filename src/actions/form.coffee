import {push} from "@dashkite/katana"

form = push (handle) ->
  r = {}
  for [key, value] from (new FormData handle.root.querySelector "form")
    r[key] = if r[key]? then [ r[key], value ] else value
  r

export {form}
