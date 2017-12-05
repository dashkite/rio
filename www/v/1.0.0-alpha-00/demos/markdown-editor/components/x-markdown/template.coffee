import HTML from "vhtml"
import {normalize} from "../helpers.coffee"

{stylesheet, div, parse} = HTML

template = ({content}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-markdown/index.css"
    div parse content ]

export {template}
