import {push} from "@dashkite/katana"

_description = (handle) -> Object.assign {}, handle.dom.dataset

description = push _description

export {description, _description}
