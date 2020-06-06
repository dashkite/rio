import {peek} from "@dashkite/katana"

prevent = peek (event) -> event.preventDefault()

export {prevent}
