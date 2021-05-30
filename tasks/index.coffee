import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"

import * as m from "@dashkite/masonry"
import { coffee } from "@dashkite/masonry/coffee"

preset t

t.define "test:build", m.start [
    m.glob [ "test/*.coffee" ], "."
    m.read
    m.tr coffee target: "node"
    m.extension ".js"
    m.write "build/node"
  ]

t.after "build", [ "pug:with-import-map", "test:build" ]
