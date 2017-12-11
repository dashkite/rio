import {Gadget} from "panda-play"
import {template} from "./template.coffee"
import MarkdownParser from "markdown-it"

class Markdown extends Gadget

  @register "x-markdown"

  @observe value: ""

  @properties
    output:
      get: do ->
        md = new MarkdownParser
          linkify: true
          typographer: true
          quotes: '“”‘’'
        -> md.render @value if @value?

  template: template
