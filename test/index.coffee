import "source-map-support/register"
import Path from "path"
import {print, test, success} from "amen"
import {wrap, flow} from "@pandastrike/garden"
import {push, pop, peek, log} from "@dashkite/katana"
import {page, defined, render, select, shadow,
  pause, clear, type, submit, evaluate, equal} from "@dashkite/mimic"
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

# coverage missing:
# - bind

do ({server, browser} = {})->

  [server, browser] = await prepare
    source: Path.resolve "test", "app"
    build: Path.resolve "test", "build"

  print await test "Carbon",  [

    test description: "Scenario: view", wait: false, flow [
      wrap [ {browser} ]
      page "http://localhost:3000"
      evaluate ->
        window.db.greetings.alice = salutation: "Hello", name: "Alice"
      defined "x-greeting"
      render "<x-greeting data-key='alice'/>"
      select "x-greeting"
      shadow
      evaluate (root) -> root.innerHTML
      equal "<p>Hello, Alice!</p>"
    ]

    test description: "Scenario: create", wait: false, flow [
      wrap [ {browser} ]
      page "http://localhost:3000"
      defined "x-create-greeting"
      render "<x-create-greeting/><x-create-greeting/>"
      select "x-create-greeting"
      shadow
      pause
      evaluate (shadow) -> shadow.adoptedStyleSheets[0].cssRules[0].cssText
      equal "form { color: blue; }"
      select "input[name='key']"
      type "bob"
      select "input[name='name']"
      type "Bob"
      select "form"
      submit
      pause
      evaluate -> window.db.greetings.bob.name
      equal "Bob"
    ]

    test description: "Scenario: update", wait: false, flow [
      wrap [ {browser} ]
      page "http://localhost:3000"
      evaluate -> window.db.greetings.alice = salutation: "Hello", name: "Alice"
      defined "x-update-greeting"
      render "<x-update-greeting data-key='alice'/>"
      select "x-update-greeting"
      shadow
      select "input[name='name']"
      clear
      type "Ally"
      select "form"
      submit
      pause
      evaluate -> window.db.greetings.alice.name
      equal "Ally"
    ]

  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
