import {curry, rtee, pipe} from "@pandastrike/garden"

_connect = curry rtee (f, type) -> type::connect = -> f [ @ ]

connect = (fx) -> _connect pipe fx

export {connect, _connect}
