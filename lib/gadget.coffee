import {properties} from "fairmont-helpers"
import {events} from "./events.coffee"
import {mixins} from "./mixins.coffee"

class Gadget

  @register: (tag) ->
    self = @
    self.Component = class extends HTMLElement
      constructor: ->
        super()
        @attachShadow mode: "open"
        @gadget = new self @
      connectedCallback: -> @gadget.connect()
    requestAnimationFrame ->
      customElements.define self.tag, self.Component
    @

  @mixins: (list) -> mixins @, list

  @events: []

  properties @::,
    tag:
      get: -> @constructor.tag
    shadow:
      get: -> @dom.shadowRoot
    html:
      get: -> @shadow.innerHTML
      set: (value) -> @shadow.innerHTML = value

  constructor: (@dom) ->

  connect: ->
    await @initialize()
    @ready()

  initialize: ->
    @initialize = ->
    @on @constructor.events
    @dispatch 'initialize'

  ready: ->

  on: (description) -> events @

  dispatch: (name) ->
    @shadow.dispatchEvent new Event name,
      bubbles: true
      cancelable: false
      # allow to bubble up from shadow DOM
      composed: true

export {Gadget}
