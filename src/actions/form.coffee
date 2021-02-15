import {pipe, tee} from "@pandastrike/garden"
import {spoke, spop, read, write} from "@dashkite/katana"

# TODO this does not handle form inputs that have multiple values
_form = (handle) ->
  Object.fromEntries (new FormData handle.root.querySelector "form")

_reset = (handle) ->
  handle.root.querySelector("form").reset()

form = pipe [
  read "handle"
  spoke _form
  write "form"
]

reset = pipe [
  read "handle"
  spop _reset
]

form._ = _form
form.reset = reset
form._reset = _reset

export {form}
