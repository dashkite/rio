import {properties} from "fairmont-helpers"
import {events} from "./events"
import {mixins} from "./mixins"

class Gadget

  @tag: (@tag) ->
    self = @
    self.Component = class extends HTMLElement
      constructor: ->
        super()
        @attachShadow mode: "open"
        @gadget = new self @
      connectedCallback: -> @gadget.connect()
    requestAnimationFrame ->
      customElements.define self.tag, self.Component
    @tag

  @properties: (description) -> properties @::, description

  @mixins: (list) -> mixins @, list

  @on: (description) -> (@events ?= []).push description

  @ready: (f) ->
    g = (event) ->
      event.target.removeEventListener event.type, g
      f.call @, event
    @on initialize: g

  @properties
    tag:
      get: -> @constructor.tag
    shadow:
      get: -> @dom.shadowRoot
    html:
      get: -> @shadow.innerHTML
      set: (value) -> @shadow.innerHTML = value

  constructor: (@dom) ->

  connect: -> @initialize()

  initialize: ->
    @initialize = ->
    @on @constructor.events
    @dispatch "initialize", local: false

  on: (description) -> events @, description

  dispatch: (name, {local} = {local: true}) ->
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: local

export {Gadget}
