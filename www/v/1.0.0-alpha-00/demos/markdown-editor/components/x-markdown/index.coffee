import {Gadget} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

parser = null
loading = do ->

  [createParser] = await require [
    "//cdnjs.cloudflare.com/ajax/libs/markdown-it/8.4.0/markdown-it.min.js"
  ]

  parser = createParser linkify: true

class Markdown extends Gadget

  @properties
    value:
      get: -> parser.render @markdown
      set: (value) ->
        @markdown = value
        @dispatch "change"
        value

  @events
    host:
      change: -> @render()

  @register "x-markdown"

  render: ->
    await loading
    super.render()

  template: template
