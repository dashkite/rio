# Play

Play is a lightweight library for building Web Components.

To create a component, you can just call `gadget`:

```coffee
import {Gadget, zen} from "panda-play"

class Greeting extends Gadget

  @tag "x-greeting"

  @mixins zen

  @on
    h1:
      click: ({target}) -> @value = "Goodbye"

  template: ({value}) -> "<h1>#{value}, World!</h1>"

```

Or you can use a more functional style:

```coffee
import {gadget, zen} from "panda-play"

gadget

  tag: "x-greeting"

  mixins: zen

  template: ({value}) -> "<h1>#{value}, World!</h1>"

  on:
    h1:
      click: ({target}) -> @value = "Goodbye"

```

## Features

- Fully encapsulated native Web Components
- Virtual DOM, with diff-based updates
- Selector-based event handlers instead of inline
- Arbitrary template functions—use template literals, JSX, Pug, …
- Or use VHTML and generate VDOM directly
- Observable properties generate change events and re-render
- Component-targetable CSS from client document
- Pipe operator to wire components together
- Delegation pattern—Gadgets are handles to DOM elements
- Mixin-based composition avoid [fragile base class problem][elliott]

[elliott]:https://medium.com/@_ericelliott/why-composition-is-immune-to-fragile-base-class-problem-8dfc6a5272aa

## Demo

[Try it out!](https://play.pandastrike.com/demos/markdown-editor)

## Install

Bundle using your favorite bundler:

```
npm i -S panda-play
```
