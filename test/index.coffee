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
    extensions: [ ".coffee" ]
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

    test "loads", ->
        content = await page.evaluate ->
          await customElements.whenDefined "x-greeting"
          document
          .querySelector "x-greeting"
          .gadget
          .test

        assert.equal content, "Hello, world!"
  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
