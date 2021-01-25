# Carbon Design Concepts

## Combinators

Carbon relies heavily on the idea of function composition. The Carbon API consists largely of functions that are intended to be composed together. We call them *combinators* because they’re meant to be combined with other functions. By themselves, combinators don’t do much. Each combinator does one thing well. However, in combination, they become quite powerful.

## Pipes and Flows

Combinators themselves often take functions as arguments.  These functions are typically defined by composing other combinators. For convenience, Carbon combinators often simply take an array of functions and does the composition for you. We refer to an array of synchronous functions as a *pipe*, while an array of (possibly) asynchronous functions is called a *flow*. Behind the scenes, combinators taking a pipe use synchronous composition, while those that take a flow use asynchronous composition, which just means they wait for any returned promises to be fulfilled before caling the next function.

## Handle Class

Carbon uses the Handle pattern to separate the state associated with the DOM element from the logical state of the component. Among other things, this avoids potential naming collisions. Typically, you define the Custom Element (using the `tag` mixin) to instantitate a handle during construction, defining a reference to the Custom Element from within the Handle (the `dom` property).

## Mixins

TBD