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
helloWorld = await $ "x-hello-world"

# Now we can use `helloWorld` as a handle on the DOM element and modify it.
helloWorld.value = "Hello, World!"
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


# Querying the DOM for all the helloWorld gadgets that are loaded
helloWorlds = await $$ "x-hello-world"
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

The `phased` mixin allows your gadget to hook into a custom element's `connectedCallback`
lifecycle callback which is invoked each time the custom element is appended
into a document-connected element ([read more about lifecycle callbacks](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements#Using_the_lifecycle_callbacks)).

The mixin exposes three gadget lifecycle hooks: `connect`, `prepare`, and
`ready`, which will be fired sequentially on gadget initialization and take as
an argument a handler function to be executed.

_**connect** handler &rarr; gadget_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| handler  | function | A function that will execute when the lifecycle hook is called |
| gadget   | gadget   | the gadget that `connect` is being mixed into. |

Fired first, and every time the gadget is inserted into the DOM.

_**prepare** handler &rarr; gadget_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| handler  | function | A function that will execute when the lifecycle hook is called |
| gadget   | gadget   | the gadget that `connect` is being mixed into. |

Fired once, after `connect` and before `ready`.

_**ready** handler &rarr; gadget_

| name     | type     | description                                            |
|----------|----------|--------------------------------------------------------|
| handler  | function | A function that will execute when the lifecycle hook is called |
| gadget   | gadget   | the gadget that `connect` is being mixed into. |

Fired after `prepare` once the gadget's element is present in the DOM and ready
for manipulation.

The three hooks are exposed for your use as well as for the use of other mixins.
This allows the mixins some granularity over when they're effects take place.
For example, the `shadow` mixin relies on the `prepare` hook to make sure the
`attachShadow` call is set before any handlers that are fired in the `ready`
hook (like the `events` mixin).

Because of the above, the order in which mixins are added can matter. You cannot
place `shadow` before `phased` (included as the first mixin the `habanera` base
preset), as an example.

### root

Returns a handle on either the dom (`@dom`) or shadowdom (`@shadow`) if the
gadget is using the `shadow` mixin.

### vdom

Adds vdom support via [diffHTML](https://github.com/tbranyen/diffhtml).

### reactor

The idea behind gadgets is that they closely resemble native elements, and so
each has a `value` property, much like a native `input` element. The `reactor`
plugin introduces getters and setters for the gadgets `value` property that emit
a `change` event when the `value` is updated.

The `reactor` mixin also introduces a `pipe` method that allows you to update
the passed in element's `value` property whenever the gadget's `value` property is
updated.

```coffee
editor = await $ "x-editor"
markdownPreview = await $ "x-markdown"

# Whenver we update the `value` of the editor gadget, we will set the value
# property for the markdownPreview gadget to match.
editor.pipe markdownPreview
```

### autorender

The `autorender` mixin adds a `render()` call to the `ready` hook added by the
`phased` mixin (essentially rendering your template even if your gadget does not
call `render` itself).

It also listens for a `change` event and will re-render itself. It works great with
`reactor` plugin (which will dispatch a `change` event when the `value`
property's setter is executed).

## Presets

### habanera

Mixin that includes the following mixins: `phased`, `root`, `evented`

This is the base mixin that includes the basics such as adding lifecycle hooks
to add your own handlers to (see `phased`), adding an easy and compact way to
attach listeners on events (see `evented`), and setting the gadgets `@root`
property to either the DOM or the shadowDOM, should a shadowDOM be attached (see
`root`).

### ragtime

Mixin that includes the following mixins: `habanera`, `vdom`

This includes all of what `habanera` offers and adds in Virtual DOM support via
`vdom` and the diffHTML libray.

### swing

Mixin that includes the following mixins: `ragtime`, `reactor`

This includes all of what `habanera` and `ragtime` offer and adds in the
`reactor` mixin, which adds getters and setters for the gadget's `@value`
property that will hook in to `autorender` as well as a helpful `pipe` function
that lets you pass in other gadgets and update their `@value` properties anytime
the parent gadget's `@value` is set.

### bebop

Mixin that includes the following mixins: `swing`, `autorender`

This includes all other presets plus the `autorender` mixin, which will
re-render the gadget anytime its `@value` property is set.
