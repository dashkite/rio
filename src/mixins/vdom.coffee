import {innerHTML} from "diffhtml"
import {follow} from "panda-parchment"
import {property} from "./helpers"

vdom = property
  html:
    # follow if not set to ensure interface
    # is consistent
    get: -> @_html ?= follow @root.innerHTML
    set: (html) ->
      @_html = innerHTML @root, html
      .then => @root.innerHTML

export {vdom}
