# Gadget Initialization

Gadget initialization has three phases:

1. _connect_—happens each time a Gadget's Web Component is attached to the DOM.
2. _prepare_—happens after the first _connect_ phase. Mixins can use this phase to add capabilities to Gadgets.
3. _initialize_—happens after _prepare_. Gadgets use this to add custom initialization.

## Interface

Each phase has a correspond array of promises. Gadgets will await the fulfillment of all the promises in the array before moving to the next phase. To add a promise to an array, use the function of the same name, passing it a function that returns value to await upon. For example, the _shadow_ mixin adds _prepare_ promise.

```
shadow = tee (type) ->
  type.prepare -> @dom.attachShadow mode: "open"
  $P type::, shadow: get: -> @dom.shadowRoot

```

That function will be run, bound the Gadget instance, after the _connect_ phase is finished. (That is, `Promise.all` returns on the resulting array.)

## Implementation

```
connect: ->
  @ready = promise (resolve, reject) =>
    await go [
      w "connect prepare initialize"  
      map (phase) => @constructor["_#{phase}"]
      map into [
        map bind @
        map apply
      ]
      wait map Promise.all
    ]
    resolve true
```

## Ready Helper

The `ready` helper adds an `initialize` handler. This is a misnomer since the `ready` promise is still unresolved. But it's simpler to write and can be read as meaning that the function will be invoked as a prerequisite for the promise being resolved.

## Event Handlers

Event handlers work the same way as before. The difference is that now they're freed from handling initialization related tasks.

## Descendent Initialization

Simply await on the Gadget selector for the descendents.

```
ready: ->
  pages = await $$ "play-page"
  # do something with pages
```

If more sophisicated initialization is required, say to hook into the _prepare_ or _connect_ phases, use a mixin. Keep in mind that attempting to access a Gadget before the _initialize_ phase is complete may be unreliable.

## Benefits

- **Simplicity.** The three phases are intrinsic to Web Component initialization, which can only happen after a Component has been connected to the DOM, and the use of mixins, which give us tremendous flexibility, but require a _prepare_ phase.
- **Predictability.** The handlers for each phase must be completed before the next phase begins. Asynchronous initialization “just works.”
- **Separation of concerns.** Simple event handling is separate from initialization. Event handler declarations are processed during the _initialization_ phase.