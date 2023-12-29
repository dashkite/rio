---
title: Tutorial
---

# Tutorial

Let’s start simple.

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
  ]
```

This creates a custom element with the tag name `x-greeting`. It doesn’t do anything interesting yet, but we’re already using some of the key features of Rio:

- We extend the `Handle` class because we interact with the custom element through its [handle][].
- We declare it as an anonymous class because it will be instantiated by the `x-greeting` custom element.
- We use [mixins][] to add features because it’s more flexible and extensible than doing everything with inheritance.

Let’s make this a Web Component by giving it a shadow root.

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      c.shadow
    ]
  ]
```

We use the `initialize` mixin instead of doing this in the constructor because that way we can use [initialize combinators][]. But we *could* have simply defined a constructor or an initialize method. Behind the scenes, that’s how this is implemented. This approach allows us to encapsulate various initialization patterns into functions and easily reuse them.

We’ve got a Web Component now, but it still doesn’t do anything. Let’s render our greeting.

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.activate [
        R.description
        R.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
] ] ]
```

The render mixin just takes a function that returns an HTML string when our component is activated, meaning it's visible in the viewport. We use the component description, which is an object reflecting it’s `dataset` property, to get the `greeting` property we use to generate our HTML. If we were to have a document that looked like this (using Pug to represent the HTML):

```pug
html
  body
    x-greeting(data-greeting = "Hello")
```

we'd get a document that rendered like this:

> ### Hello, World!

Let’s make it more interactive, so that we can change the greeting by clicking on it.

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.activate [
        R.description
        R.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      R.event "click", [
        R.within "h1", [
          R.intercept
          R.call -> @dom.dataset.greeting = "Hola"
] ] ] ]
```

We add an event handler with the `event` initalizer mixin. We rely on [event delegation][], which means the event has bubbled up to the component root element. We check to make sure the event originated from within the H1. In this simple example, the only possible source of the event is the H1, but we include the `within` combinator anyway. We intercept the event (calling `preventDefault` and `stopPropagation` on the event) and update the `greeting` property of the component’s dataset. The `call` combinator binds *this* to the handle before calling the function, so you can use instance variables freely.

We also adopt a convention here of closing out brackets once we get to more than 2 or 3 layers of nesting.

Rio provides convenience methods for common events, so we can rewrite this as:

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.activate [
        R.description
        R.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      R.click "h1", [
        R.call -> @dom.dataset.greeting = "Hola"
  ] ] ]
```

The only problem is that we need to re-render now when we change the greeting. So let's take care of that as well:

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

template = ({greeting}) -> "<h1>#{greeting}, World!</h1>"

class extends R.Handle
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.activate [
        R.description
        R.render template
      ]
      R.describe [
        R.render template
      ]
      R.click "h1", [
        R.call -> @dom.dataset.greeting = "Hola"
  ] ] ]
```

The `describe` mixin observes the data attributes of the component. When we change the `data-greeting` property from _Hello_ to _Hola_, the component re-renders the HTML and we get:

> ### Hola, World!

This is one style of a reactive component, but there are other patterns we could implement by using different combinators. That’s the advantage of using combinators: instead of a one-size-fits-all data flow, we can tailor it for each type of component.


If we click on the greeting, it will change from _Hello_ to _Hola_. Let’s add more greetings. We’ll do this by adding some state to our handle to keep track of the current greeting.

```coffeescript
import * as R from "@dashkite/rio"
import * as Meta from "@dashkite/joy/metaclass"

template = ({greeting}) -> "<h1>#{greeting}, World!</h1>"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

class extends R.Handle
  current: 0
  Meta.mixin @, [
    R.tag "x-world-greetings"
    R.initialize [
      R.shadow
      R.activate [
        R.description
        R.render template
      ]
      R.describe [
        R.render template
      ]
      R.click "h1", [
        R.call ->
          @current = ++@current % greetings.length
          @dom.dataset.greeting = greetings[@current]
  ] ] ]
```

The handle is an ordinary class and so it can have properties and methods like any other class. In this case, we’ve added the `current` property.

In JavaScript, this is slightly more verbose but the code is semantically identical.

If this were a more complex component, we might be concerned about re-rendering each time, in which case we'd use the `diff` combinator. You can learn more about `diff` and the various other combinators Rio provides in the [Quick Reference][].

[handle]: ./design-concepts.md#handle
[mixins]: ./design-concepts.md#mixins
[Quick Reference]: ./quick-reference.md
[initialize combinators]: ./quick-reference.md#initialize-combinators
[event delegation]: https://davidwalsh.name/event-delegate
