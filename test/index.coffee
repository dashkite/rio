import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as m from "@dashkite/mimic"
import browser from "@dashkite/genie-presets/browser"

do ->

  await do browser ({browser, port}) ->

    results = await test "Carbon", [

      test
        description: "Scenario: view"
        wait: false
        m.launch browser, [
          m.page
          m.goto "http://localhost:#{port}/"
          m.evaluate ->
            window.db.greetings.alice = salutation: "Hello", name: "Alice"
          m.defined "x-greeting"
          m.select "body"
          m.render "<x-greeting data-key='alice'/>"
          m.select "x-greeting"
          m.shadow
          m.innerHTML
          m.assert "<p>Hello, Alice!</p>"
        ]

      test
        description: "Scenario: create"
        wait: false
        m.launch browser, [
          m.page
          m.goto "http://localhost:#{port}"
          m.defined "x-create-greeting"
          m.select "body"
          m.render "<x-create-greeting></x-create-greeting>"
          m.pause
          m.select "x-create-greeting"
          m.shadow
          m.select "input[name='key']"
          m.type "bob"
          m.select "input[name='name']"
          m.type "Bob"
          m.select "form"
          m.submit
          m.pause
          m.evaluate -> window.db.greetings.bob.name
          m.assert "Bob"
      ]

      test
        description: "Scenario: update"
        wait: false
        m.launch browser, [
          m.page
          m.goto "http://localhost:#{port}"
          m.evaluate ->
            window.db.greetings.alice =
              salutation: "Hello"
              name: "Alice"
          m.defined "x-update-greeting"
          m.select "body"
          m.render "<x-update-greeting data-key='alice'/>"
          m.pause
          m.select "x-update-greeting"
          m.shadow
          m.select "input[name='name']"
          m.clear
          m.type "Ally"
          m.select "form"
          m.submit
          m.pause
          m.evaluate -> window.db.greetings.alice.name
          m.assert "Ally"
        ]

      test
        description: "Scenario: tutorial"
        wait: false
        m.launch browser, [
          m.page
          m.goto "http://localhost:#{port}"
          m.defined "x-world-greetings"
          m.select "body"
          m.render "<x-world-greetings data-greeting='Hello'/>"
          m.pause
          m.select "x-world-greetings"
          m.shadow
          m.select "h1"
          m.click
          m.pause
          k.discard
          m.select "h1"
          m.text
          m.assert "Hola, World!"
        ]

    ]

    print results
