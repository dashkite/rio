import * as t from "@dashkite/genie"
import * as b from "@dashkite/brick"
import * as q from "panda-quill"
import coffee from "coffeescript"

# TODO build tests using zenpack

t.define "clean", -> q.rmr "build"

t.define "build", "clean", b.start [
  b.glob [ "{src,test}/**/*.coffee" ], "."
  b.read
  b.tr ({path}, code) ->
    coffee.compile code,
      bare: true
      inlineMap: true
      filename: path
      transpile:
        presets: [[
          "@babel/preset-env"
          targets: node: "current"
        ]]
  b.extension ".js"
  b.write "build"
]

t.define "test", "build", ->
  b.node "build/test/index.js", [ "--enable-source.maps" ]
