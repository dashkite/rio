import {Play} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

# TODO: make these instance methods?
Tabs =
  create: (label) ->
    # base tab object with helper methods
    tab =
      select: ->
        for node in [ @dom.tab, @dom.label, @dom.content ]
          node.classList.add "selected"
      deselect: ->
        for node in [ @dom.tab, @dom.label, @dom.content ]
          node.classList.remove "selected"
      dom:
        query: (s) -> @component.querySelector s
        label: label
        slots:
          query: (name) ->
            tab.dom.main.querySelector "slot[name='#{name}']"

    # add getters using closure
    Object.defineProperties tab,
      name: get: -> (label.getAttribute "slot").replace "-label", ""
      label: get: -> label.textContent

    # here we can use label directly as object property
    Object.defineProperties tab.dom,
      component: get: -> @label.parentNode
      main: get: -> @component.main
      content: get: -> @query "[slot='#{tab.name}-content']"
      tab: get: -> @slots.content.parentNode

    Object.defineProperties tab.dom.slots,
      label: get: -> @query "#{tab.name}-label"
      content: get: -> @query "#{tab.name}-content"

    tab

  getAll: (component) ->
    for label in (component.querySelectorAll "label[slot]")
      Tabs.create label

  deselectAll: (component) ->
    tab.deselect() for tab in Tabs.getAll component

  select: (label) ->
    (Tabs.create label).select()

class Gadget extends Play

  schema:
    tabs:
      type: array
      get: -> Tabs.getAll @

  template: template

  events:
    label:
      click: ({target}) ->
        Tabs.deselectAll @
        Tabs.select target

  ready: -> (Tabs.getAll @)[0].select()

Gadget.register "x-tabs"
