## Type: `Gadget`

### Constructor

_**constructor** element &rarr; gadget_

| Name          | Type       | Description            |
| ------------- | ---------- | ---------------------- |
| element       | DOMElement | The Custom Element.    |
| &rarr; gadget | Gadget     | A new Gadget instance. |

Constructs a new Gadget. Takes a corresponding Custom Element that the Gadget will proxy. Usually not invoked directly. Instead, call `gadget` with the Custom Element to obtain the proxy, which ensures that the Gadget is initialized and ready for use.

### Mixins

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
| decorate   | Decorate   |
| autorender | Autorender |
| template   | Template   |

#### Factories

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

#### Presets

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

#### `updates`

### Methods

#### `lock`

#### `decorate`

#### `pipe`

## Features: Decorator

### Methods

#### `decorate`

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
| decorate   | method                          | Defines the `decorate` method, which should accept a value and returned a modified value. Useful in conjunction with the `reactor` mixin. |
| on         | object                          | Event handlers that will be defined during initialization.   |
| once       | object                          | Event handlers that will be defined during initialization, but declared using `once` set to true. |
| ready      | method                          | Short hand for defining an `initialize` event handler using `once.` |

#### `render`

#### `update`

## Asynchronous Processing

