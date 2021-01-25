# Carbon

Carbon is a lightweight library for building Web Components. Instead of relying on arcane hooks or other “magical” conventions, Carbon makes everything explicit. Carbon defines a variety of simple functions that can be composed together to provide the behavior you need for a given component. This works similarly to method chaining, except you can add your own functions.

For example, here's a simple Hello, World variant. (Yes, the examples use CoffeeScript. We like CoffeeScript. You may feel differently. You can use Carbon with JavaScript or any other JavaScript-friendly language.) We define a common data flow pattern, where a change to the `greeting` property will re-render the component.

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    c.diff
    c.initialize [
      c.shadow
      c.sheet "main", "body { margin: 32px; } h1 { font-size: 48px; }"
      c.click "h1", [
        c.call ->
          @greeting = if @greeting == "Hello" then "Goodbye" else "Hello"
      ]
      c.observe "greeting", [
        c.render ({greeting}) -> "<h1>#{greeting}, world!</h1>"
      ]
    ]
```

## Features

- Fully encapsulated native Web Components
- Lightweight: 24kB minified/gzipped
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

- [Tutorial](./tutorial.md)
- [Design Concepts](./design-concepts.md)
- [Quick Reference](quick-reference.md)