import HTML from "vhtml"
import {normalize} from "../helpers.coffee"

{stylesheet, textarea} = HTML

template = ({value}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-editor/index.css"
    textarea value ]

export {template}
