import * as _ from "@dashkite/joy"
import * as c from "@dashkite/carbon"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

template =  ({greeting}) -> "<h1>#{greeting}, World!</h1>"

class extends c.Handle
  current: 0
  rotate: ->
    @dom.dataset.greeting = greetings[++@current % greetings.length]
  _.mixin @, [
    c.tag "x-world-greetings"
    c.initialize [
      c.shadow
      c.activate [
        c.description
        c.render template
      ]
      c.describe [
        c.render template
      ]
      c.click "h1", [
        c.call @::rotate
      ]
  ] ]
