import $ from "../lib/dom-helpers.js"

$.ready ->
  $.on ($ "x-editor"),
    change: ({target: {data}}) ->
      ($ "x-markdown")
      .data.markdown = data.content
