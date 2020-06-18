import {curry, flow} from "@pandastrike/garden"
import {push, read} from "@dashkite/katana"

# TODO this does not handle form inputs that have multiple values
_fields = curry (names, data) ->
  names.reduce ((r, name) -> {r..., [name]: data[name]}), {}

fields = (names) ->
  flow [
    read "form"
    push _fields names
  ]

export {fields, _fields}
