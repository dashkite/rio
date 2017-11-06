import {define} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"


define "x-tabs",

  data:
    names:
      get: ->
        (child.getAttribute "slot") for child in @$.children


  template: template

  events:
    label:
      click: ({target}) ->
