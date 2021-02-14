# Carbon Tutorial

Let’s start simple.

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
  ]
```

This creates a custom element with the tag name `x-greeting`. It doesn’t do anything interesting yet, but we’re already using some of the key features of Carbon:

- We extend the `Handle` class because we interact with the custom element through its [handle][].
- We declare it as anonymous class because it will be instantiated by the `x-greeting` custom element.
- We use [mixins][] instead of inheritance because it’s more flexible and extensible.

Let’s make this a Web Component by giving it a shadow root.

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    c.initialize [
    	c.shadow
    ]
  ]
```

We use the `initialize` mixin instead of doing this in the constructor because that way we can use [initialize combinators][]. But we *could* have simply defined a constructor or an initialize method. Behind the scenes, that’s how this is implemented. This approach allows us to encapsulate various initialization patterns into functions and easily reuse them.

We’ve got a Web Component now, but it still doesn’t do anything. Let’s render our greeting.

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    c.initialize [
    	c.shadow
      c.describe [
        c.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
    ]
  ]
```

The render mixin just takes a function that returns an HTML string. We use the component description, which is an object reflecting it’s `dataset` property, to get the `greeting` property we use to generate our HTML. If we were to have a document that looked like this (using Pug to represent the HTML):

```pug
html
  body
    x-greeting(data-greeting = "Hello")
```

we'd get a document that rendered like this:

> ### Hello, World!

The `describe` mixin also observes the data attributes of the component. If we were to change the `data-greeting` property from _Hello_ to _Hola_, the component would re-render the HTML and we’d get:

> ### Hola, World!

This is one style of a reactive component, but there are other patterns we could implement by using different combinators. That’s the advantage of using combinators: instead of a one-size-fits-all data flow, we can tailor it for each type of component.

Let’s make it more interactive, so that we can change the greeting by clicking on it.

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    c.initialize [
    	c.shadow
      c.describe [
        c.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      c.event "click", [
        c.within "h1", [
          c.intercept
          c.call -> @dom.dataset.greeting = "Hola"
  ] ] ] ]
```

We add an event handler with the `event` initalizer mixin. We rely on [event delegation][], which means the event has bubbled up to the component root element. We check to make sure the event originated from within the H1. In this simple example, the only possible source of the event is the H1, but we include the `within` combinator anyway. We intercept the event (calling `preventDefault` and `stopPropagation` on the event) and update the `greeting` property of the component’s dataset. The `call` combinator binds *this* to the handle before calling the function, so you can use instance variables freely.

We also adopt a convention here of closing out parenthesis once we get to more than 2 or 3 layers of nesting.

Carbon provides convenience methods for common events, so we can rewrite this as:

```coffeescript
import c from "@dashkite/carbon"

class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    c.initialize [
    	c.shadow
      c.describe [
        c.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      c.click "h1", [
    	  c.call -> @dom.dataset.greeting = "Hola"
  ] ] ]
```

If we click on the greeting, it will change from _Hello_ to _Hola_. Let’s add more greetings. We’ll do this by adding some state to our handle to keep track of the current greeting.

```coffeescript
import c from "@dashkite/carbon"

greetings = [ "Hello", "Hola", "Bonjour", "Ciao", "Nǐ hǎo", "Konnichiwa", "Mahalo" ]

class extends Handle
  current: 0
  rotate: -> @dom.dataset.greeting = greetings[++@current]
  c.mixin @, [
    c.tag "x-greeting"
    c.initialize [
      c.shadow
      c.describe [
        c.render ({greeting}) -> "<h1>#{greeting}, World!</h1>"
      ]
      c.click "h1", [
        c.call -> @rotate()
  ] ] ]
```

The handle is an ordinary class and so it can have properties and methods like any other class. In this case, we’ve added the `current` property and a `rotate` method.

In JavaScript, this is slightly more verbose because of the syntax and because we can't inline the call to `mixin`, but the code is semantically identical.

```javascript
import c from "@dashkite/carbon";

const greetings = [ "Hello", "Hola", "Bonjour", "Ciao",
  "Nǐ hǎo", "Konnichiwa", "Mahalo"];

class Greeting extends Handle {
  current = 0
  rotate() {
    return this.dom.dataset.greeting = greetings[++this.current];
  }
};

c.mixin(Greeting, [
  c.tag("x-greeting"),
  c.initialize([
    c.shadow,
    c.describe([
      c.render(=> {greeting} `<h1>${greeting}, World!</h1>`)
    ]),
    c.click("h1", [
      // we can't use => syntax here because call binds to the handle instance
      c.call(function() { this.rotate(); })
    ])
  ])
]);
```

If this were a more complex component, we might be concerned about re-rendering each time

[handle]: ./design-concepts.md#handle
[mixins]: ./design-concepts.md#mixins
[initialize combinators]: ./quick-reference.md#initialize-combinators
[event delegation]: https://davidwalsh.name/event-delegate
