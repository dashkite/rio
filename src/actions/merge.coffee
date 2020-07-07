import {curry, flip, flow} from "@pandastrike/garden"
import {mpoke} from "@dashkite/katana"

_merge = curry (value, target) -> Object.assign target, value

merge = (name) -> mpoke _merge

merge._ = _merge

export {merge}
