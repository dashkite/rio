import {use, innerHTML} from "diffhtml"
import {readwrite} from "../helpers"

# This hook provides us a way to flag an element within a component to be exempt
# from diffHTML's reconcilation cycle by convention.
# TODO: Upgrade this when diffHTML beta 19 is released, allowing us to target nodes on the newTree directly. Right now, this is limited to top level children, which will suffices, but is incomplete.
use
  syncTreeHook: (oldTree, newTree) ->
    # Ignore style elements.
    if oldTree.nodeName == "#document-fragment"

      append = []
      prepend = []
      anchored = []

      # Scan for carbonSkip
      for child in oldTree.childNodes
        if child.attributes["data-carbon-skip"]?
          if child.attributes["data-carbon-skip"] == "prepend"
            prepend.push child
          else if child.attributes["data-carbon-skip"] == "append"
            append.push child
          else
            anchored.push child

      # prepend and append are easy and already in their order
      newTree.childNodes.unshift prepend...
      newTree.childNodes.push append...

      # Anchors prepend to target, so reverse to pick up chained inert nodes.
      for child in anchored.reverse()
        for el, index in newTree.childNodes
          if el.attributes.key == child.attributes["data-carbon-skip"]
            newTree.childNodes.splice index, 0, child
            break

      return newTree

diff = (type) ->
  readwrite type::,
    html:
      get: ->
        await @_tx if @_tx?
        @root.innerHTML
      set: (html) -> @_tx = innerHTML @root, html

export {diff}
