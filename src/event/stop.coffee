import {peek} from "@dashkite/katana"

stop = peek (event) -> event.stopPropagation()

export {stop}
