import {peek} from "@dashkite/katana"

# TODO should this use the arity of f to get the arguments?
bind = (f) -> peek (handle) -> f.call handle

export {bind}
