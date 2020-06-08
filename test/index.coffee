import "source-map-support/register"
import Path from "path"
import {print, test, success} from "amen"
import {wrap, flow} from "@pandastrike/garden"
import {push, pop, peek} from "@dashkite/katana"
import {page, defined, render, select, shadow,
  pause, type, submit, evaluate, equal} from "./combinators"
import {bundle, clean, pug, server, browser} from "./helpers"

prepare = ({source, build})->

  await clean build
  await Promise.all [
    bundle source, build
    pug source, build
  ]
  Promise.all [
    server build
    browser()
  ]

do ({server, browser} = {})->

  [server, browser] = await prepare
    source: Path.resolve "test", "app"
    build: Path.resolve "test", "build"

  print await test "Carbon",  [

    test description: "Scenario: view", wait: false, flow [
      wrap [ browser ]
      push page "http://localhost:3000"
      peek defined "x-greeting"
      peek render "<x-greeting data-name='alice'/>"
      push select "x-greeting"
      push shadow
      push evaluate (root) -> root.innerHTML
      peek equal "<p>Hello, Alice!</p>"
    ]

    test description: "Scenario: create", wait: false, flow [
      wrap [ browser ]
      push page "http://localhost:3000"
      peek defined "x-create-greeting"
      peek render "<x-create-greeting/>"
      push select "x-create-greeting"
      push shadow
      push select "input"
      pop type "Alice"
      push select "form"
      pop submit
      peek pause
      push evaluate -> window.greeting?.name
      peek equal "Alice"
    ]

  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
