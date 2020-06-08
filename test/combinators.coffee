import {curry} from "@pandastrike/garden"
import assert from "assert"

page = curry (url, browser) ->
  do ({page} = {}) ->
    page = await browser.newPage()
    page.on "console", (message) -> console.log "<#{url}>", message.text()
    page.on "pageerror", (error) -> console.error "<#{url}>", error
    await page.goto url
    page

defined = curry (name, page) ->
  page.evaluate -> customElements.whenDefined "x-greeting"

render = curry (html, page) ->
  page.evaluate ((html) -> document.body.innerHTML = html), html

select = curry (selector, node) -> node.$ selector

shadow = (node) -> node.evaluateHandle (node) -> node.shadowRoot

sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

pause = -> sleep 100

type = curry (text, node) -> node.type text

submit = (form) -> form.evaluate (form) -> form.requestSubmit()

evaluate = curry (f, node) -> node.evaluate f

equal = curry (expected, actual) -> assert.equal expected, actual


export { page, defined, render, select, shadow,
  sleep, pause, type, submit, evaluate, equal }
