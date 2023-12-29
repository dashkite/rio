import * as _ from "@dashkite/joy"
import * as R from "@dashkite/rio"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

template =  ({greeting}) -> "<h1>#{greeting}, World!</h1>"

class extends R.Handle
  current: 0
  rotate: ->
    @dom.dataset.greeting = greetings[++@current % greetings.length]
  _.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.describe [
        R.render template
      ]
      R.click "h1", [
        R.call @::rotate
      ]
  ] ]
