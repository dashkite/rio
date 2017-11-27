import HTML from "/v/1.0.0-alpha-00/lib/vhtml.js"
{stylesheet, div, parse} = HTML

import {normalize} from "../helpers.js"

template = ({value}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-markdown/index.css"
    div parse value ]

export {template}
