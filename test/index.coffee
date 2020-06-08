import "source-map-support/register"
import Path from "path"
import assert from "assert"
import {print, test, success} from "amen"
import puppeteer from "puppeteer"
import webpack from "webpack"
import express from "express"
import files from "express-static"
import pug from "pug"
import {wrap, curry, flow} from "@pandastrike/garden"
import {stack, push, pop, peek} from "@dashkite/katana"
import {collect, tee, wait} from "panda-river"
import {rmr, mkdirp} from "panda-quill"
p9k = require "panda-9000"

source = Path.resolve "test", "app"
build = Path.resolve "test", "build"

compiler = webpack
  mode: "development"
  devtool: "inline-source-map"
  entry: Path.join source, "index.coffee"
  resolve:
    mainFiles: [ "index" ]
    extensions: [ ".js", ".coffee" ]
    modules: [ "node_modules" ]
  output:
    path: build
    filename: "index.min.js"
  module:
    rules: [
      test: /.coffee$/
      loader: "coffee-loader"
    ]

compiler.watch {}, (error) ->
  if error? then console.error error

app = express()
  .use files Path.join build


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

page = curry (url, browser) ->
  do ({page} = {}) ->
    page = await browser.newPage()
    page.on "console", (message) -> console.log "<#{url}>", message.text()
    page.on "pageerror", (error) -> console.error "<#{url}>", error
    await page.goto url
    page

do ->

  await rmr build
  await mkdirp "0777", "build"

  await do flow [
    wrap p9k.glob "**/*.pug", source
    wait tee p9k.read
    tee (context) ->
      context.target.content = pug.render context.source.content,
        filename: context.source.path
        basedir: source
    tee p9k.extension ".html"
    wait tee p9k.write build
    collect
  ]

  server = await app.listen 3000
  browser = await puppeteer.launch()

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

    test description: "Scenario: create", wait: false, stack flow [
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
