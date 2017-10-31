import {define} from "/v/1.0.0-alpha-00/lib/component-helpers.js"
import {template} from "./template.js"


define "x-editor",

  data: content: ""

  template: template

  events:
    textarea:
      keyup: ({target}) ->
        @data.content = target.value
        @emit "change"
