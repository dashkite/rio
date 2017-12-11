# Play

Play is a lightweight library for building Web Components.

To create a component, just extend `Gadget`:

```coffee
import {Gadget} from "panda-play"

class Greeting extends Gadget

  @register "x-editor"

  @observe value: "Hello"

  template: ({value}) -> "<h1>#{value}, World!</h1>"

  @events
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

## Demo

[Try it out!](https://play.pandastrike.com/v/1.0.0-alpha-00/demos/markdown-editor)

## Install

Bundle using your favorite bundler:

```
npm i -S panda-play
```

Standalone and JavaScript module distributions coming soon.
