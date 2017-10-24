import {define} from "../../../lib/component-helpers.js"
import {template} from "./template.js"


define "x-editor",

  data: content: ""

  template: template

  events:
    textarea:
      keyup: ({target}) ->
        @data.content = target.value
        @emit "change"
