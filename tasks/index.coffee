import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import browse from "@dashkite/genie-presets/browse"

preset t

import assert from "assert/strict"
import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as m from "@dashkite/mimic"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"

t.after "build", "pug:with-import-map"

t.define "test", [ "build" ], browse ({browser, port}) ->

  do m.launch browser, [
    m.page
    m.goto "http://localhost:#{port}/"
    m.waitFor -> window.__test?
    m.evaluate -> window.__test
    k.peek (result) ->
      try
        print result
      catch error
        console.log error.message
  ]
