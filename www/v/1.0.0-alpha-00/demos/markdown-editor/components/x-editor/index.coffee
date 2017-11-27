import {Gadget} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

class Editor extends Gadget

  @properties
    value:
      get: -> @content
      set: (value) ->
        @content = value
        @dispatch "change"
        value

  @events
    textarea:
      keyup: ({target}) -> @value = target.value

  @register "x-editor"

  template: template
