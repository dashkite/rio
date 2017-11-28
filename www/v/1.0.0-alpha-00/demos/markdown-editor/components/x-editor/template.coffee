import HTML from "/v/1.0.0-alpha-00/lib/vhtml.js"
{stylesheet, textarea} = HTML

import {normalize} from "../helpers.js"

template = ({value}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-editor/index.css"
    textarea value ]

export {template}
