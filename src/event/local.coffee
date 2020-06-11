import {curry} from "@pandastrike/garden"

local = curry (event, handle) -> event.detail == handle

export {local}
