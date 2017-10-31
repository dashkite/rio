import $ from "/v/1.0.0-alpha-00/lib/dom-helpers.js"

$.ready ->
  $.on ($ "x-editor"),
    change: ({target: {data}}) ->
      ($ "x-markdown")
      .data.markdown = data.content
