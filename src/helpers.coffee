import {curry, tee} from "@pandastrike/garden"

readonly = curry tee (target, descriptor) ->
  for name, f of descriptor
    Object.defineProperty target, name, get: f

readwrite = curry tee (target, descriptor) ->
  for name, definition of descriptor
    Object.defineProperty target, name, definition

export {readonly, readwrite}
