import {flow, tee} from "@pandastrike/garden"
import {poke, read, write} from "@dashkite/katana"

# TODO this does not handle form inputs that have multiple values
_form = (handle) ->
  Object.fromEntries (new FormData handle.root.querySelector "form")

_reset = (handle) ->
  handle.root.querySelector("form").reset()

form = flow [
  read "handle"
  poke _form
  write "form"
]

reset = tee flow [
  read "handle"
  poke _reset
]

form._ = _form
form.reset = reset
form._reset = _reset

export {form}
