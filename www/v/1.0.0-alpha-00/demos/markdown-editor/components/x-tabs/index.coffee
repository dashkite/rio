import {define} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

nameFromLabel = (label) ->
  (label.getAttribute "slot")?.replace "-label", ""

contentSlotFromName = (root, name) ->
  root.querySelector "slot[name='#{name}-content']"

contentFromName = (root, name) ->
  root.querySelector "[slot='#{name}-content']"

contentSlotFromLabel = (root, label) ->
  contentSlotFromName root, nameFromLabel label

contentFromLabel = (root, label) ->
  contentFromName root, nameFromLabel label

tabFromContentSlot = (node) -> node?.parentNode

tabFromLabel = (root, label) ->
  tabFromContentSlot contentSlotFromLabel root, label

select = (node) -> node?.classList?.add? "selected"

deselect = (node) -> node?.classList?.remove? "selected"

getAllLabels = (root) -> root.querySelectorAll "label[slot]"

getFirstLabel = (root) -> root.querySelector "label[slot]"

createTabDescriptorFromLabel = (label) ->
  name: nameFromLabel label
  label: label.textContent

getAllContentSlots = (root) ->
  root.querySelectorAll "slot[name$='-content']"

define "x-tabs",

  data:
    tabs:
      get: ->
        for label in (getAllLabels @$)
          createTabDescriptorFromLabel label

  template: template

  events:
    label:
      click: ({target}) ->
        for label in (getAllLabels @)
          deselect label
          deselect tabFromLabel @main, label
          deselect contentFromLabel @, label
        select target
        select tabFromLabel @main, target
        select contentFromLabel @, target

  ready: ->
    select (label = getFirstLabel @)
    select tabFromLabel @main, label
    select contentFromLabel @, label
