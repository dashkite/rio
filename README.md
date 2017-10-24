# Play

Play is a lightweight library for building Web Components.

To create a component, just `import` Play's `define` function:

```coffee
import {define} from "https://play.pandastrike.com"
  + "/versions/1.0.0-alpha-00/component-helpers.js"

define "x-greeting",

  data: greeting: "Hello"

  template: "<h1>#{greeting}, World!"

  events:
    h1: click: -> @data.greeting = "Goodbye"
```

## How It Works

Play uses [diffHTML](https://diffhtml.org/) to diff the DOM and make lightning fast updates. Events are bubbled up to the Shadow DOM root and matched using `DOM.match`. A JavaScript Proxy watches for changes to the component's data.
