# Quick Reference

Reminder: we refer to an array of synchronous functions as a *pipe*, while an array of (possibly) asynchronous functions is called a *flow*. 

## Handle Class

Carbon uses the Handle pattern to separate the state associated with the DOM element from the logical state of the component. Among other things, this avoids potential naming collisions. Typically, you define the Custom Element (using the `tag` mixin) to instantitate a handle during construction, defining a reference to the Custom Element from within the Handle (the `dom` property).

## Mixin Combinators

Mixin combinators are “top-level” combinators that “mixin” features into the Handle. You can use the `mixin` function for this:

```coffeescript
class extends Handle
  c.mixin @, [
    c.tag "x-greeting"
    # ... more mixins ...
  ]
```

(Handles may be anonymous classes since they’re only instantiated by a Custom Element, never directly.)

| Name       | Arguments | Description                                                  |
| ---------- | --------- | ------------------------------------------------------------ |
| connect    | pipe      | Define the handler for the `connectedCallback`.              |
| diff       | -         | Defines (or overrides) the `html` property that updates the DOM using a [diff algorithm](https://diffhtml.org/). |
| initialize | pipe      | Defines the handler for the handle construction.             |
| tag        | name      | Defines the Custom Element class and registers it with the tag name. |

## Initialize Combinators

These can be used with the `initialize` or `connect` mixin combinators.

| Name       | Arguments      | Description                                                  |
| ---------- | -------------- | ------------------------------------------------------------ |
| activate   | flow           | Defines a handler for *activation*, when the component becomes visible in the viewport. |
| click      | selector, flow | Defines a handler for a click event targeting the given selector. Convenience combinator. |
| deactivate | flow           | Defines a handler for deactivation, when the component is no longer visible in the viewport. |
| describe   | flow           | Defines a handler for changes to the component's dataset. The component’s *description* (an object corresponding to the component’s dataset) is passed into the flow. |
| event      | pipe           | Defines a handler for the given event, ex: `click`. Uses [event delegation](https://davidwalsh.name/event-delegate). |
| observe    | name, flow     | Defines and [observes](https://github.com/gullerya/object-observer) the named property in the handle. Defines a handler for changes. |
| shadow     | -              | Create a `shadowRoot` for the component, accessible via the handle `shadow` property. |
| sheet      | name, css      | Applies the CSS or stylesheet to the component and associates it with the given name. (Named stylesheets allows you to [add and remove stylesheets](https://github.com/dashkite/stylist) in without recompling them.) |

## Action Combinators

| Name | Arguments | Description |
| ---- | --------- | ----------- |
| assign | name | Assign (via [`Object.assign`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign)) the receved value to the named property. |
| call | function | Call the function, with `this` bound to the handle. |
| description | - | Pass the component description (an object  corresponding to the component’s dataset) to the next function. |
| form | - | Pass an object corresponding to the component FormData to the next function. |
| get | name | Pass the value of the named property to the next function. |
| render     | template       | Render the element to the DOM using the given template. The template takes the handle instance and returns an HTML string. |
| set        | name | Sets the named property to the received value. |

## Event Combinators

| Name      | Arguments      | Description                                                  |
| --------- | -------------- | ------------------------------------------------------------ |
| intercept | -              | Convenience combinator for  `prevent` and `stop`.            |
| contains  | selector, flow | Invokes the given flow only if the event target contains the selector. |
| prevent   | -              | Calls `preventDefault` on the received event.                |
| stop      | -              | Calls `stopPropagation` on the received event.               |
| target    | -              | Passes the event target to the next function.                |

