import { pipe, tee } from "@dashkite/joy/function"
import { poke, pop, read, write } from "@dashkite/katana/sync"

_form = ( handle ) ->
  
  if ( form = handle.root.querySelector "form" )?
    Object.fromEntries ( new FormData form )
  else {}

_reset = ( handle ) ->
  handle.root.querySelector( "form" ).reset()

form = pipe [
  read "handle"
  poke _form
]

reset = pipe [
  read "handle"
  pop _reset
]

export { form, reset }
