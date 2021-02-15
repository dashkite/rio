# import * as c from "@dashkite/carbon"
import * as c from "../../../src"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

class extends c.Handle
  current: 0
  rotate: -> @dom.dataset.greeting = greetings[++@current % greetings.length]
  c.mixin @, [
    c.tag "x-world-greetings"
    c.initialize [
      c.shadow
      c.describe [
        c.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      c.click "h1", [
        c.call @::rotate
      ]
  ] ]
