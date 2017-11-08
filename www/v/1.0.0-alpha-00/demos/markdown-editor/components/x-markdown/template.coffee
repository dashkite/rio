import HTML from "/v/1.0.0-alpha-00/lib/vhtml.js"
{normalize, stylesheet, div, parse} = HTML


template = ({html}) ->
  [ normalize()
    stylesheet "/v/1.0.0-alpha-00/demos/markdown-editor\
                  /components/x-markdown/index.css"
    div [ parse html ] ]

export {template}
