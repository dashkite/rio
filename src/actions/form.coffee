import { pipe } from "@dashkite/joy/function"
import { poke, pop, read, write } from "@dashkite/katana/sync"

# TODO this does not handle form inputs that have multiple values
_form = ( handle ) ->
  Object.fromEntries ( new FormData handle.root.querySelector "form" )

_reset = ( handle ) ->
  handle.root.querySelector( "form" ).reset()

form = pipe [
  read "handle"
  poke _form
  write "form"
]

reset = pipe [
  read "handle"
  pop _reset
]

export { form, reset }
