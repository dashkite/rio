import HTML from "/v/1.0.0-alpha-00/lib/vhtml.js"
{normalize, stylesheet, textarea} = HTML


template = ({content}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-editor/index.css"
    textarea content ]

export {template}
