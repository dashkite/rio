## Type: `Gadget`

Gadgets are wrappers around, or handles for, a Web Component. This allows us to work seamlessly with Virtual DOM or other useful abstractions without concerning ourselves with conflicts with the existing DOM API. Gadgets delegate many operations to its DOM node or handle events on its behalf.

The Gadget base type is not intended to be used directly. It's only responsibility is to bind a Gadget instance to a DOM node when constructed, and to provide a base class from which to derive new types of Gadgets. Mixins make it easy to add common features, such as support for Shadow DOM or reactive rendering.

### Constructor

_**constructor** element &rarr; gadget_

| Name          | Type       | Description            |
| ------------- | ---------- | ---------------------- |
| element       | DOMElement | The Custom Element.    |
| &rarr; gadget | Gadget     | A new Gadget instance. |

Constructs a new Gadget. Takes a corresponding Custom Element that the Gadget will proxy. Usually not invoked directly. Instead, call `gadget` with the Custom Element to obtain the proxy, which ensures that the Gadget is initialized and ready for use.

## Mixins

Use mixins to add Features to your Gadget.

- *Mixins* are just functions that take a type, modify it, and return it.
- Mixin *factories* are functions that return mixins, which allows mixins to be parameterized.
- *Features* are collections of related properties, methods, events, and event handlers.
- *Presets* are collections of mixins that group common combinations of mixins.

| Mixin      | Features   |
| ---------- | ---------- |
| evented    | Evented    |
| root       | Root       |
| shadow     | Shadow     |
| html       | HTML       |
| vdom       | VDOM       |
| reactor    | Reactor    |
| autorender | Autorender |
| template   | Template   |

### Factories

| Factory    | Features   |
| ---------- | ---------- |
| tag        | Component  |

#### `tag`

_**tag** name &rarr; mixin_

_**tag** {name, extends} &rarr; mixin_

| Name          | Type   | Description                                              |
| ------------- | ------ | -------------------------------------------------------- |
| name          | string | The name of the tag corresponding to the Custom Element. |
| extends | string | Built-in Element to extend. |
|  &rarr; mixin             | mixin | A mixin for Component Features. |

To declare a Custom Element with no Shadow DOM, use the `extends` option to inherit from a built-in element.

You typically would access this mixin factory by setting the `tag` property of a Gadget definition, rather than calling it directly.

##### Example: With Tacit Shadow DOM

```coffee
gadget
  tag: "stream"
```

##### Example: Without Shadow DOM

```coffee
gadget
  tag: name: "play-page", extends: "div"
```

### Presets

| Preset     | Mixins                         |
| ---------- | ------------------------------ |
| ragtime    | evented, root, vdom, template  |
| swing      | ragtime, autorender            |
| bebop      | swing, reactor                    |

## Features: Component

### Properties

#### `T.tag`

- Tag name of the associated Custom Element.
- Read-only.

#### `T.Component`

- Class of the Custom Element.
- Read-only.

#### `tag`

- Convenience property for `T.tag`.

## Features: Evented

### Event Description

- Event descriptions specify event handlers for a Gadget.
- Typically, you pass event description to the Gadget's `on` method.
- Event descriptions are dictionaries, where the keys may be selectors or event names.
- If the key is a selector, the value is a dictionary whose keys are event names.
- If the key is an event name, the value is an event handler description or function.
- When a selector is provided, the event handler will not be called unless the selector matches the event target.
- A special `host` selector will match the event target to the Gadget's DOM node for events fired with the Gadget's `dispatch` method.
- The event handler will be registered via `addEventListener` using the event name.
- Event handler descriptions must have a `handler` property with the event handler.
- Event handler descriptions may also include `bubble` and `once` properties.
- If an event handler description defines `bubble` as true, `stopPropagation` will be called on the event prior to invoking the handler.
- If an event handler description defines `once` as true, the listener will be defined using the `once` option and so the handler will only be invoked once.

### Properties

#### `isReady`

### Methods

#### `T.on`

#### `T.ready`

#### `on`

#### `connect`

_**connect** &rarr; undefined_

Called by the Custom Element when its `connectedCallback` is invoked. Takes no arguments and has no defined return value. Sets up a `connect`  event listener with `once` set to `true` to fire an `initialize` event. Dispatches `connect` event.

### dispatch

## Features: Root

### Properties

#### `root`

## Features: HTML

### Properties

#### `html`

## Features: Shadow

### Properties

#### `shadow`

### Handlers

#### `initialize`

## Features: Reactor

### Properties

#### `value`

### Methods

#### `lock`

#### `pipe`

## Features: VDOM

### Properties

#### `html`

## Features: Autorender

### Handlers

#### `initialize`

#### `change`

## Features: Template

### Methods

#### `render`

## Functions

#### `define`

_**define** &rarr; derived-type_

- Returning _derived-type_: type. Returns a type derived from Gadget.

#### `gadget`

_**gadget** dom &rarr; promise<gadget>_

- _dom:_ a Custom Element.
- _promise<gadget>:_ a promise resolving to a Gadget instance wrapping the Custom Element, ready for use.

Given a Custom Element, returns the corresponding Gadget proxy, if one exists, ready for use.

_**gadget** description &rarr; derived-type_

- _description:_ an object describing a type derived from Gadget.
- _derived-type_: an type derived from gadget.

Given a _description_, returns a class derived from Gadget.

##### Example

```coffee
gadget
  tag: "post"
  mixins: [ shadow, bebop ]
  template: template
```

##### Gadget Description

| Name       | Type                            | Description                                                  |
| ---------- | ------------------------------- | ------------------------------------------------------------ |
| tag        | string                          | The tag corresponding to the Custom Element, ex: `x-component`. Required. |
| mixins     | mixin&nbsp;\|&nbsp;array<mixin> | Mixins to be applied to the class.                           |
| properties | dictionary<property>            | Describes the properties of an instance. The schema for the description is similar to that of `Object.defineProperties`, except that `enumerable` and `configurable` default to `true`. |
| property   | dictionary<property>            | Alias for `properties`.                                      |
| methods    | dictionary<method>              | Describes the methods for an instance.                       |
| method     | dictionary<method>              | Alias for `methods`.                                         |
| on         | object                          | Event handlers that will be defined during initialization.   |
| once       | object                          | Event handlers that will be defined during initialization, but declared using `once` set to true. |
| ready      | method                          | Short hand for defining an `initialize` event handler using `once.` |

#### `render`

#### `update`

## Asynchronous Processing

Play offers features, through mixins, that allow rigorous control over the processing flow. The Reactive and VDOM Features, together, allow you to ensure that a Gadget is in a well-defined state before doing anything further.

### Promised Properties

These features rely on _promised properties_, promises whose value is a promise that resolves to a well-defined value for any given iteration of the event loop. They introduce two promised properties:

- `value`: useful for components that have state outside the DOM.
- `html`: the DOM tree for the component's root.

Promised properties allow each component to encapsulate its state while supporting asynchronous network operations and DOM events.

### Update And Render Events

Both of these properties have corresponding events that are fired whenever they're updated.

| Property | Event  |
| -------- | ------ |
| value    | update |
| html     | render |

Since these are promised properties, your event handler cannot access them without first waiting for the promise to resolve. In turn, this ensures that they're in a well-defined state when you access them.

```coffee
on:
  host:
    render: ->
      @extractLinks await @html
```

### Yielding Control

When handling the resolved value from a promised property, you may need to yield control of the event loop. For example, you may need to wait for another promise to resolve or a callback to be invoked. When control is returned the resolved value may no longer be in a well-defined state. There are three potential ways to manage this:

- Make a (deep) copy of the value.
- Use a decorator (useful *during* an update).
- Use a lock (useful in between updates).

#### Make A Copy

This is the simplest solution. Simply make a copy of the value (or at least the parts you need) before performing an asynchronous operations. You can update the copy, knowing you control its state and, if necessary, reassign the property.

#### Decorators And Custom Setters

Decorators hook into the setter for a promised property to allow for asynchronous processing during assignment. Alternatively, you could write a Setter to do this.

Decorators are being considered as part of the Play roadmap. In order to support them generally, we will use a value container that acts as a proxy for the real value. This would allow for mixins to additively support a variety of useful patterns, including copy-on-write, decorators, and nested values.

#### Locks

Locks help ensure that only one thread of execution is modifying value at any one time. This is particular useful for DOM updates that happen outside of the Play rendering cycle. Locking may also be supported in future versions of Play. Since every access to a value must agree to use a given lock, they're a last resort.

### Pipes

You can pipe the value of one component to another using the `pipe` method, which is just a shorthand for defining an event handler to do assignment.