import {use, innerHTML} from "diffhtml"
import {readwrite} from "../helpers"

use
  syncTreeHook: (oldTree, newTree) ->
    # Ignore style elements.
    if oldTree.nodeName == "#document-fragment"
      styles = []
      for child in oldTree.childNodes
        styles.push child if child.nodeName == "style"

      newTree.childNodes.unshift styles...
      return newTree

diff = (type) ->
  readwrite type::,
    html:
      get: ->
        await @_tx if @_tx?
        @root.innerHTML
      set: (html) -> @_tx = innerHTML @root, html

export {diff}
