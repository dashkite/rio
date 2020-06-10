# TODO this does not handle form inputs that have multiple values
form = (handle) ->
  Object.fromEntries (new FormData handle.root.querySelector "form")

export {form}
