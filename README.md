# Carbon

Carbon is a lightweight library for building Web Components.

```coffeescript
class
  constructor: (@dom) ->
  mixin @, [
    tag "x-greeting"
    vdom
    sheet select "h1", type "heading large"
    connect [
      shadow
      event "click", [
        matches "h1"
        intercept
        bind ->
          if @greeting == "Hello"
            @greeting = "Goodbye"
          else
            @greeting = "Hello"
      ]
      observe "greeting", [
        render -> "<h1>#{@greeting}, world!</h1>"
      ]
    ]
```

## Features

- Fully encapsulated native Web Components
- Virtual DOM, with diff-based updates
- Render with simple HTML
- Parse CSS once and attach using CSSOM
- Observable properties
- Explicit ordering without hooks
- Uses handle pattern to avoid naming conflicts

## Install

Bundle using your favorite bundler:

```
npm i @dashkite/carbon
```

## API

### Class Mixins

#### `tag`

Define the tag for the Custom Element.

```coffeescript
tag "x-greeting"
```

#### `connect`

Define the handler for the `connectedCallback`, in the form of an array of functions.

### Connect Combinators

#### `shadow`

Define a `shadowRoot` for the component, accessible via the handle as `shadow`.