import {innerHTML} from "diffhtml"
import {follow} from "panda-parchment"
import {property} from "./helpers"

vdom = property
  html:
    get: -> @_html ?= @root.innerHTML
    set: (html) -> innerHTML @root, html

export {vdom}
