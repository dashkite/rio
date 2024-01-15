import { curry } from "@dashkite/joy/function"

local = curry (event, { handle }) -> event.detail == handle

export { local }
