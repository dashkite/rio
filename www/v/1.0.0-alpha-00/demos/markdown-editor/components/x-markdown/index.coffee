import {Play} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

parser = null
loading = do ->

  [createParser] = await require [
    "//cdnjs.cloudflare.com/ajax/libs/markdown-it/8.4.0/markdown-it.min.js"
  ]

  parser = createParser linkify: true

class Markdown extends Play

  schema:
    markdown:
      type: string
      value: ""
      proxy: true
    html:
      type: string
      get: -> parser.render @markdown

  events:
    host:
      change: -> @render()

  template: template

  render: ->
    await loading
    super.render()

Markdown.register "x-markdown"
