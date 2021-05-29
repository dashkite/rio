import assert from "@dashkite/assert"
import * as a from "@dashkite/amen"
import * as c from "@dashkite/carbon"

do ->

  window.__test = await a.test "Carbon", [
  ]

  #
  #   a.test description: "Scenario: view", wait: false, _.flow [
  #     _.wrap [ {browser} ]
  #     m.page
  #     m.goto "http://localhost:#{port}"
  #     m.evaluate ->
  #       window.db.greetings.alice = salutation: "Hello", name: "Alice"
  #     m.defined "x-greeting"
  #     m.render "<x-greeting data-key='alice'/>"
  #     m.select "x-greeting"
  #     m.shadow
  #     m.evaluate (root) -> root.innerHTML
  #     m.equal "<p>Hello, Alice!</p>"
  #   ]
  #
  #   a.test description: "Scenario: create", wait: false, _.flow [
  #     _.wrap [ {browser} ]
  #     m.page
  #     m.goto "http://localhost:#{port}"
  #     m.defined "x-create-greeting"
  #     m.render "<x-create-greeting/><x-create-greeting/>"
  #     m.select "x-create-greeting"
  #     m.shadow
  #     m.pause
  #     # m.evaluate (shadow) -> shadow.adoptedStyleSheets[0].cssRules[0].cssText
  #     # m.equal "form { color: blue; }"
  #     m.select "input[name='key']"
  #     m.type "bob"
  #     k.discard
  #     m.select "input[name='name']"
  #     m.type "Bob"
  #     k.discard
  #     m.select "form"
  #     m.submit
  #     m.pause
  #     m.evaluate -> window.db.greetings.bob.name
  #     m.equal "Bob"
  #   ]
  #
  #   a.test description: "Scenario: update", wait: false, _.flow [
  #     _.wrap [ {browser} ]
  #     m.page
  #     m.goto "http://localhost:#{port}"
  #     m.evaluate ->
  #       window.db.greetings.alice =
  #         salutation: "Hello"
  #         name: "Alice"
  #     m.defined "x-update-greeting"
  #     m.render "<x-update-greeting data-key='alice'/>"
  #     m.select "x-update-greeting"
  #     m.shadow
  #     m.select "input[name='name']"
  #     m.clear
  #     m.type "Ally"
  #     k.discard
  #     m.select "form"
  #     m.submit
  #     m.pause
  #     m.evaluate -> window.db.greetings.alice.name
  #     m.equal "Ally"
  #     _.flow [
  #       k.read "page"
  #       k.poke (page) -> page.content()
  #     ]
  #   ]
  #
  #   a.test description: "Scenario: tutorial", wait: false, _.flow [
  #     _.wrap [ {browser} ]
  #     m.page
  #     m.goto "http://localhost:#{port}"
  #     m.defined "x-world-greetings"
  #     m.render "<x-world-greetings data-greeting='Hello'/>"
  #     m.select "x-world-greetings"
  #     m.shadow
  #     m.select "h1"
  #     m.click
  #     m.pause
  #     k.discard
  #     m.select "h1"
  #     k.poke (node) -> node.evaluateHandle (node) -> node.textContent
  #     m.equal "Hola, World!"
  #   ]
  # ]
  #
  # await browser.close()
  # server.close()
  #
