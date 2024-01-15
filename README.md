# Rio

Rio is a lightweight library for building reactive Web Components. Instead of relying on hooks, Rio makes everything explicit. Rio defines a variety of simple functions that can be composed together to provide the behavior you need for a given component. This works similarly to method chaining, except you can add your own functions.

For example, here's a simple Hello, World variant in CoffeeScript. (Yes, we use CoffeeScript. We like CoffeeScript. You may feel differently. You can use Rio with JavaScript or any other JavaScript-friendly language.) We define a common data flow pattern, where a change to the `greeting` property will re-render the component.

```coffeescript
import * as Meta from "@dashkite/joy/metaclass"
import * as R from "@dashkite/rio"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

class extends R.Handle
  current: 0
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.describe [
        R.render ({ greeting }) -> "<h1>#{ greeting }, World!</h1>"
      ]
      c.click "h1", [
        c.call -> 
    			@current = ++@current % greetings.length
    			@dom.dataset.greeting = greetings[ @current ]
      ]
    ]
  ]
```

## Features

- Fully encapsulated native Web Components
- Lightweight: 29.4kB minified/gzipped
- Virtual DOM, with diff-based updates
- Render with simple HTML
- Parse CSS once and attach using CSSOM
- Observable properties
- Explicit, reactive data flow without hooks

## Install

Install with your favorite package manger:

```
pnpm i @dashkite/rio
```

## Learn More

- [Tutorial](./docs/tutorial.md)
- [Design Concepts](./docs/design-concepts.md)
- [Quick Reference](./docs/quick-reference.md)
