---
title: Quick Reference
---
# Quick Reference

## Terminology

| Term       | Meaning                                                      |
| ---------- | ------------------------------------------------------------ |
| combinator | A function intended to be combined with other functions via composition. |
| pipe       | An array of synchronous functions (that will be composed using `pipe`). |
| flow       | An array of (possibly) asynchronous functions (that will be composed using `flow`). |
| input(s)   | A value (or values) passed into combinator.                  |
| component  | A Web Component or Custom Element.                           |
| handle     | An object that encapsulates a component.                     |

## Handle Class

### Properties

| Name   | Description                                                  |
| ------ | ------------------------------------------------------------ |
| root   | If the component is a Web Component, refers to `shadow`, otherwise refers to `dom`. |
| dom    | A reference to the component itself.                         |
| shadow | A reference to the component’s shadow DOM, if applicable. May be defined using the `shadow` initialization combinator. |
| html   | Reflects the component’s `innerHTML` property. The `diff` initialization combinator redefines this to perform a diff instead of setting `innerHTML` directly. |

### Methods

| Name     | Arguments     | Description                                                  |
| -------- | ------------- | ------------------------------------------------------------ |
| on       | name, handler | Define an event handler using `addEventListener` for the named event. |
| dispatch | name, detail  | Dispatch the named event using `dispatchEvent` for the named event, with optional `detail` property. |

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
| connect    | pipe      | Define the handler for the [`connectedCallback`](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements#using_the_lifecycle_callbacks). |
| diff       | -         | Defines (or overrides) the `html` property that updates the DOM using a [diff algorithm](https://diffhtml.org/). |
| disconnect | pipe      | Define the handler for the [`disconnectedCallback`](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements#using_the_lifecycle_callbacks). [Not yet implemented.] |
| initialize | pipe      | Defines the handler for the handle construction. Called once during the component lifecycle. |
| tag        | name      | Defines the custom element class and registers it with the tag name. |

## Initialize Combinators

Initialize combinators can be used with the `initialize` or `connect` mixin combinators. Iniitalize combinators are always synchronous.

| Name       | Arguments      | Description                                                  |
| ---------- | -------------- | ------------------------------------------------------------ |
| activate   | flow           | Defines a handler for *activation*, when the component becomes visible in the viewport. |
| click      | selector, flow | Defines a handler for a click event targeting the given selector. Convenience combinator. |
| deactivate | flow           | Defines a handler for deactivation, when the component is no longer visible in the viewport. |
| describe   | flow           | Defines a handler for changes to the component's dataset. The component’s *description* (an object corresponding to the component’s dataset) is passed into the flow. |
| event      | name, pipe     | Defines a handler for the named event, ex: `click`. Uses [event delegation](https://davidwalsh.name/event-delegate). |
| navigate   | name, flow     | Define a handler for window navigation (`popstate` events).  |
| observe    | name, flow     | Defines and [observes](https://github.com/gullerya/object-observer) the named property in the handle. Defines a handler for changes. |
| ready      | -              | Defines a handler for when initialization is complete. Useful for adding asynchronous actions into initialization, such as `render`. |
| shadow     | -              | Create a `shadowRoot` for the component, accessible via the handle `shadow` property. |
| submit     | select, flow   |                                                              |

## Action Combinators

Action combinators are typically used within flows in response to events. Action combinators may be synchronous or asynchronous. The event loop yields after each action regardless. However, synchronous combinators may be used as initializers.

| Name | Arguments | Type | Description |
| ---- | --------- | ----------- | ---- |
| assign | name | sync | Assign (via [`Object.assign`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) the input to the named property. |
| call | function | async | Call the function, with `this` bound to the handle. |
| description | - | sync | Returns the component description (an object  corresponding to the component’s dataset). |
| disable | - | sync | Disable all enabled form inputs. |
| dispatch | name | sync | Dispatch an event from the component. |
| enable | - | sync | Enable all disabled form inputs. |
| form | - | sync | Returns an object corresponding to the component FormData. |
| get | name | async | Returns the value of the named property. |
| render     | template       | async | Render the element to the DOM using the given template. The template takes the handle instance and returns an HTML string. |
| reset | - | sync | Resets the component form inputs. |
| set        | name | sync | Sets the named property to the input. |
| sheet      | dictionary, css | sync | Applies a dictionary of named stylesheets (CSS or Stylesheet objects) to the component. (Named stylesheets allow you to [add and remove stylesheets](https://github.com/dashkite/stylist) in without recompling them.) |

## Event Combinators

Event combinators are used to compose event handlers. A common pattern is to test if the event target is contained by an element with a given selector and run a flow.

```coffeescript
c.event "click", [
  c.within "h1", [
	  c.intercept
    c.call ->
      @greeting = if @greeting == "Hello" then "Goodbye" else "Hello"
  ]
]
```

| Name      | Arguments      | Description                                                  |
| --------- | -------------- | ------------------------------------------------------------ |
| intercept | -              | Convenience combinator for  `prevent` and `stop`.            |
| matches   | selector, pipe | Invokes the given flow only if the target matches the selector. |
| within    | selector, pipe | Invokes the given flow only if an ancestor of the target matches the selector. |
| prevent   | -              | Calls `preventDefault` on the input event.                   |
| stop      | -              | Calls `stopPropagation` on the input event.                  |
| target    | -              | Returns the event target.                                    |
