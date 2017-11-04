import {define} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"


define "x-editor",

  data: content: ""

  template: template

  events:
    textarea:
      keyup: ({target}) ->
        @data.content = target.value
