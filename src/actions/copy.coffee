import * as K from "@dashkite/katana"

copy = K.peek ( value ) -> navigator.clipboard.writeText value

export { copy }
