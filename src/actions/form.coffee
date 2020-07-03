import {flow} from "@pandastrike/garden"
import {poke, read, write} from "@dashkite/katana"

# TODO this does not handle form inputs that have multiple values
_form = (handle) ->
  Object.fromEntries (new FormData handle.root.querySelector "form")

form = flow [
  read "handle"
  poke _form
  write "form"
]

form._ = _form

export {form}
