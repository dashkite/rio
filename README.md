# Carbon

Carbon is a lightweight library for building Web Components. Instead of relying on arcane hooks or other “magical” conventions, Carbon makes everything explicit. Carbon defines a variety of simple functions that can be composed together to provide the behavior you need for a given component. This works similarly to method chaining, except you can add your own functions.

For example, here's a simple Hello, World variant. (Yes, the examples use CoffeeScript. We like CoffeeScript. You may feel differently. You can use Carbon with JavaScript or any other JavaScript-friendly language.) We define a common data flow pattern, where a change to the `greeting` property will re-render the component.

```coffeescript
import * as _ from "@dashkite/joy"
import * as c from "@dashkite/carbon"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

class extends c.Handle
  current: 0
  rotate: -> @dom.dataset.greeting = greetings[++@current % greetings.length]
  _.mixin @, [
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
```

## Features

- Fully encapsulated native Web Components
- Lightweight: 29.4kB minified/gzipped
- Virtual DOM, with diff-based updates
- Render with simple HTML
- Parse CSS once and attach using CSSOM
- Observable properties
- Explicit data flow without hooks or “magic”

## Install

Bundle using your favorite bundler (Webpack, Rollup, etc.):

```
npm i @dashkite/carbon
```

## Learn More

- [Tutorial](./docs/tutorial.md)
- [Design Concepts](./docs/design-concepts.md)
- [Quick Reference](./docs/quick-reference.md)
