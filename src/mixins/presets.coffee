import {pipe} from "panda-garden"
import {phased} from "./phased"
import {evented} from "./evented"
import {vdom} from "./vdom"
import {root, render} from "./render"
import {reactor, autorender} from "./reactor"

habanera = pipe phased, root, evented
ragtime = pipe habanera, vdom
swing = pipe ragtime, reactor
bebop = pipe swing, autorender

export {habanera, ragtime, swing, bebop}
