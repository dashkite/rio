import {Gadget} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

properties = (object, descriptors) ->
  for name, descriptor of descriptors
    descriptor.enumerable ?= true
    Object.defineProperty object::, name, descriptor

class Tab

  constructor: (label) ->
    @name = (label.getAttribute "slot").replace "-label", ""
    @label = label.textContent
    @dom = new Tab.DOM @name, label

  select: ->
    for node in [ @dom.tab, @dom.label, @dom.content ]
      node.classList.add "selected"

  deselect: ->
    for node in [ @dom.tab, @dom.label, @dom.content ]
      node.classList.remove "selected"

  class @DOM

    properties @,
      tabs: get: -> @label.parentNode
      shadow: get: -> @tabs.shadowRoot
      content: get: -> @query "[slot='#{@name}-content']"
      tab: get: -> @slots.content.parentNode

    constructor: (@name, @label) ->
      @slots = new Tab.DOM.Slots @name, @

    query: (s) -> @tabs.querySelector s


    class @Slots

      properties @,
        label: get: -> @query "#{@name}-label"
        content: get: -> @query "#{@name}-content"

      constructor: (@name, @dom) ->

      query: (name) -> @dom.shadow.querySelector "slot[name='#{name}']"


class Tabs extends Gadget

  @register "x-tabs"

  @properties
    tabs: get: ->
      (new Tab label) for label in (@dom.querySelectorAll "label[slot]")

  events: ->
    @on
      label:
        click: ({target}) =>
          for tab in @tabs
            if tab.dom.label == target
              tab.select()
            else
              tab.deselect()

  template: template

  ready: -> @tabs[0].select()
