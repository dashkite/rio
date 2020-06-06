import {innerHTML} from "diffhtml"
import {tee} from "@pandastrike/garden"
import {readwrite} from "../helpers"

diff = tee (type) ->
  readwrite type::,
    html:
      get: ->
        await @_tx if @_tx?
        @root.innerHTML
      set: (html) -> @_tx = innerHTML @root, html

export {diff}
