# Play

Play is a lightweight library for building Web Components.

To create a component, just extend `Gadget`:

```coffee
import {Gadget} from "//play.pandastrike.com/v/1.0.0-alpha-00/play.js"

class Greeting extends Gadget

  @register "x-editor"

  @observe value: "Hello"

  template: ({value}) -> "<h1>#{value}, World!</h1>"

  @events
    h1:
      click: ({target}) -> @value = "Goodbye"

```

## How It Works

Play uses [diffHTML](https://diffhtml.org/) to diff the DOM and make lightning fast updates. Events are bubbled up to the Shadow DOM root and matched using `DOM.match`. Change events are fired when observed values are changed. By default, change events trigger a render.

## Demo

[Try it out!](https://play.pandastrike.com/v/1.0.0-alpha-00/demos/markdown-editor)
