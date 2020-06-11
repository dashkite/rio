import {push} from "@dashkite/katana"

# TODO this does not handle form inputs that have multiple values
_form = (handle) ->
  Object.fromEntries (new FormData handle.root.querySelector "form")

form = push _form

export {form, _form}
