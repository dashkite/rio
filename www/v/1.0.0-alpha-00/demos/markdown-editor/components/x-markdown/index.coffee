import {Gadget} from "/v/1.0.0-alpha-00/lib/play.js"
import {template} from "./template.js"

properties = (self, descriptors) ->
  for name, descriptor of descriptors
    descriptor.enumerable ?= true
    Object.defineProperty self, name, descriptor

parser = null
loading = do ->

  [createParser] = await require [
    "//cdnjs.cloudflare.com/ajax/libs/markdown-it/8.4.0/markdown-it.min.js"
  ]

  parser = createParser linkify: true

  class Markdown extends Gadget

    @register "x-markdown"

    properties @::,
      content:
        get: -> parser.render @value if @value?

    template: template
