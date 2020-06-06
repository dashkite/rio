import {curry, tee} from "@pandastrike/garden"

getter = curry tee (target, descriptor) ->
  for name, f of descriptor
    Object.defineProperty target, name, get: f

export {getter}
