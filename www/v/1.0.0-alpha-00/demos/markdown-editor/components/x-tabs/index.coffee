import {define} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"


define "x-tabs",

  data:
    tabs:
      get: ->
        for child in @$.children
          name: (child.getAttribute "slot")
          label: (child.querySelector "label").textContent


  template: template

  events:
    label:
      click: ({target}) ->

  ready: ->
    @data.selected = @data.tabs[0].name
