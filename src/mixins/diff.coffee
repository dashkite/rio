import { innerHTML } from "diffhtml"
import { tee } from "@dashkite/joy/function"
import { mixin, property } from "@dashkite/joy/metaclass"

# This hook provides us a way to flag an element within a component
# to be exempt from diffHTML's reconcilation cycle by convention.


#       append = []
#       prepend = []
#       anchored = []

#       # Scan for carbonSkip
#       for child in oldTree.childNodes
#         if child.attributes["data-carbon-skip"]?
#           if child.attributes["data-carbon-skip"] == "prepend"
#             prepend.push child
#           else if child.attributes["data-carbon-skip"] == "append"
#             append.push child
#           else
#             anchored.push child

#       # prepend and append are easy and already in their order
#       newTree.childNodes.unshift prepend...
#       newTree.childNodes.push append...

#       # Anchors prepend to target, so reverse to pick up chained inert nodes.
#       for child in anchored.reverse()
#         for el, index in newTree.childNodes
#           if el.attributes.key == child.attributes["data-carbon-skip"]
#             newTree.childNodes.splice index, 0, child
#             break

#       return newTree

diff = tee ( type ) ->
  mixin type::, [
    property "html",
      get: ->
        await @_tx if @_tx?
        @root.innerHTML
      set: ( html ) -> 
        @_tx = innerHTML @root, html
  ]

export { diff }
