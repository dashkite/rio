# Play API Reference

> These are a work in progress.

## Gadget

### $

_**$** value &rarr; promise\<gadget\>_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| value    | string   | a string that identifies the `tag` of the gadget you wish to query for |
| gadget   | promise  | a promise that wraps the gadget that is loaded and ready in the DOM |

#### Example

```coffeescript
# Our x-hello-world Gadget definition.
class extends Gadget

  mixin @, [

    tag "x-hello-world"

    # ... additional mixins omitted for brevity
  ]


# Querying the DOM for the gadget that has loaded and is `ready`
hello_world = await $ "x-hello-world"

# Now we can use `hello_world` as a handle on the DOM element and modify it.
hello_world.value = "Hello, World!"
```

### $$

_**$$** value &rarr; promise\<gadget[]\>_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| value    | string   | a string that identifies the `tag` of the gadgets you wish to query for |
| gadget   | promise  | a promise that wraps the gadgets that are loaded and ready in the DOM |

#### Example

```coffeescript
# Our x-hello-world Gadget definition.
class extends Gadget

  mixin @, [

    tag "x-hello-world"

    # ... additional mixins omitted for brevity
  ]


# Querying the DOM for all the hello_world gadgets that are loaded
hello_worlds = await $$ "x-hello-world"
```

## Mixins

### evented

The `evented` mixin permits adding event listeners to a gadget by passing an
object describing the selectors and events to listen for to the `events` function.

### events

_**events** value &rarr; gadget_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| value    | object   | an object with keys (selectors to listen on) and values (events to listen for). |
| gadget   | gadget   | the gadget that `events` is being mixed into. |

You define the listeners by passing an object describing the selectors and
events to listen for to the `events` function. Each key of the description
object is a selector to listen on and each value is an object that identifies
the DOM event to listen for and the corresponding functions to execute as its
keys/values.

#### Structure of the description object passed to `events`:
```coffeescript
# selector:
#   event:
#     function to execute when event is fired.
```

#### Example

```coffeescript
# Our x-hello-world Gadget definition.
class extends Gadget

  mixin @, [

    evented # allows us to use `events` below.

    tag "x-hello-world"

    template -> "<h1>Hello, world!</h1>"

    events
      h1:
        click: -> alert("You clicked me!")

    # ... additional mixins omitted for brevity

  ]
```

### phased

The `phased` mixin function allows your gadget to tap into the [Web Component
Lifeycle Hooks](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements#Using_the_lifecycle_callbacks).... 

TBD... Ready/Prepare/Connect... seek further clarity.

### root

Returns a handle on either the dom (`@dom`) or shadowdom (`@shadow`) if the
gadget is using the `shadow` mixin.

### vdom

Adds vdom support via [diffHTML](https://github.com/tbranyen/diffhtml).

### reactor

### autorender

On change the gadget will re-render.

## Presets

### habanera

Mixin that includes the following mixins: `phased`, `root`, `evented`

### ragtime

Mixin that includes the following mixins: `habanera`, `vdom`

### swing

Mixin that includes the following mixins: `ragtime`, `reactor`

### bebop

Mixin that includes the following mixins: `swing`, `autorender`
