import {curry, tee} from "@pandastrike/garden"

readonly = curry tee (target, descriptor) ->
  for name, f of descriptor
    Object.defineProperty target, name, get: f

readwrite = curry tee (target, descriptor) ->
  for name, definition of descriptor
    Object.defineProperty target, name, definition

dispatch = (target, name, detail) ->
  target.dispatchEvent new CustomEvent name,
    detail: detail
    bubbles: false
    cancelable: false
    # don't allow to bubble up from shadow DOM
    composed: false


export {readonly, readwrite, dispatch}
