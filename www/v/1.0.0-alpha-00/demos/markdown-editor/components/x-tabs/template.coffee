import HTML from "/v/1.0.0-alpha-00/lib/vhtml.js"
{stylesheet, div, slot, ul, li} = HTML

import {normalize} from "../helpers.js"

content = (tabs) ->
  for tab in tabs
    div class: "tab", [ slot name: "#{tab.name}-content" ]

menu = (tabs) ->
  ul do ->
    for tab in tabs
      li [ slot name: "#{tab.name}-label" ]

preamble = ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-tabs/index.css" ]

template = ({tabs}) -> [ preamble(), (menu tabs), (content tabs) ]

export {template}
