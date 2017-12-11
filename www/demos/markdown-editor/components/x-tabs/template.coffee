import HTML from "vhtml"
import css from "./index.styl"

{style, div, slot, ul, li} = HTML

content = (tabs) ->
  for tab in tabs
    div class: "tab", [ slot name: "#{tab.name}-content" ]

menu = (tabs) ->
  ul do ->
    for tab in tabs
      li [ slot name: "#{tab.name}-label" ]

preamble = ->
  [ style css ]

template = ({tabs}) -> [ preamble(), (menu tabs), (content tabs) ]

export {template}
