import {Play} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

class Editor extends Play

  schema:
    content:
      type: string
      value: ""
      proxy: true

  template: template

  events:
    textarea:
      keyup: ({target}) -> @value = target.value

Editor.register "x-editor"
