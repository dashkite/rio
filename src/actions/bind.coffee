import {peek} from "@dashkite/katana"

# TODO should this use the arity of f to get add'l arguments?
# ex: replace event with data from event target, then call bind
bind = (f) -> peek (handle) -> f.call handle

export {bind}
