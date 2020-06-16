import {innerHTML} from "diffhtml"
import {readwrite} from "../helpers"

diff = (type) ->
  readwrite type::,
    html:
      get: ->
        await @_tx if @_tx?
        @root.innerHTML
      set: (html) -> @_tx = innerHTML @root, html

export {diff}
