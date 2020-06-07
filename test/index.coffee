import "source-map-support/register"
import Path from "path"
import assert from "assert"
import {print, test, success} from "amen"
import puppeteer from "puppeteer"
import webpack from "webpack"
import express from "express"
import files from "express-static"
import pug from "pug"
import {wrap, flow} from "@pandastrike/garden"
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

compiler.watch {}, ->

app = express()
  .use files Path.join build

sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

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
  page = await browser.newPage()
  page.on "console", (message) -> console.log "browser:", message.text()
  page.on "pageerror", (error) -> console.error "browser:", error
  await page.goto "http://localhost:3000"

  print await test "Carbon",  [

    test "Scenario: view", ->
      result = await page.evaluate ->
        document.body.innerHTML = "<x-greeting data-name='alice'/>"
        await customElements.whenDefined "x-greeting"
        root = document
          .querySelector "x-greeting"
          .shadowRoot
        new Promise (resolve) ->
          requestAnimationFrame -> resolve root.innerHTML

      assert.equal result, "<p>Hello, Alice!</p>"

    test description: "Scenario: create", wait: false, ->

      await page.evaluate ->
        document.body.innerHTML = "<x-create-greeting/>"

      await page.evaluate ->
        customElements.whenDefined "x-create-greeting"

      component = await page.$ "x-create-greeting"

      root = await component.evaluateHandle (node) -> node.shadowRoot
      input = await root.$ "input"
      await input.type "Alice"

      await root.$eval "form", (form) -> form.requestSubmit()

      await sleep 100

      data = await component.evaluate (component) -> window.greeting

      assert.equal data.name, "Alice"

  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
