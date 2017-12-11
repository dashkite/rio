import {Gadget} from "panda-play"
import {template} from "./template.coffee"

class Editor extends Gadget

  @register "x-editor"

  @observe value: ""

  @events
    textarea:
      keyup: ({target}) -> @value = target.value

  template: template
