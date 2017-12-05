import {Gadget} from "play"
import {template} from "./template.coffee"
import createParser from "markdown-it"

properties = (self, descriptors) ->
  for name, descriptor of descriptors
    descriptor.enumerable ?= true
    Object.defineProperty self, name, descriptor

class Markdown extends Gadget

  @register "x-markdown"

  @observe value: ""

  properties @::,
    content:
      get: do ->
        parser = createParser linkify: true
        -> parser.render @value if @value?

  template: template
