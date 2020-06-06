# Carbon

Carbon is a lightweight library for building Web Components.

```coffeescript
class Greeting extends Handle
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
          if @value.greeting == "Hello"
            @value.greeting = "Goodbye"
          else
            @value.greeting = "Hello"
      ]
      observe "value", [
        render -> "<h1>#{@data.greeting}, world!</h1>"
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

#### `diff`

Define `html` property that will update the DOM using a [diff algorithm](https://diffhtml.org/) instead of replacing it.

#### `connect`

Define the handler for the `connectedCallback`, in the form of an array of functions.

### Connect Combinators

#### `shadow`

Define a `shadowRoot` for the component, accessible via the handle as `shadow`.

#### `describe`

Defines a `description` getter corresponding to the component’s `dataset` and listens for changes to it, calling the given handlers.

```coffeescript
describe [
  render -> "<h1>Hello, #{@description.name}<h1>"
]
```

#### `observe`

Wraps the given property in a proxy that listens for changes to the object (or array). The property becomes readonly. This behavior is analogous to the way `describe` works with the component’s `dataset` property.

For example, given the following handler:

```coffeescript
observe "value", [
  render -> "<h1>Hello, #{@value.name}<h1>"
]
```

updating properties of `value` will call it:

```coffeescript
handle.value.name = "Alice"
```

However, you cannot assign to `value`:

```coffeescript
# this is effectively a no-op
handle.value = name: "Alice"
```

If the value is an object, you can use `Object.assign` to avoid nesting:

```coffeescript
Object.assign handle.value, name: "Alice"
```

If the property is undefined, it will be initialized as an empty object.

#### `event`

Register an event handler for the root of the component (which will either be the shadow root or the component itself) and define a handler in the form of an array of functions. Use `matches` to handle events for element within the component.