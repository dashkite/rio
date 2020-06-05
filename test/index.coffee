import Path from "path"
import assert from "assert"
import {print, test, success} from "amen"
import puppeteer from "puppeteer"
import webpack from "webpack"
import express from "express"
import files from "express-static"

directory = Path.resolve "test", "app"

compiler = webpack
  mode: "development"
  entry: Path.join directory, "index.js"
  output:
    path: directory
    filename: "index.min.js"

compiler.watch {}, ->

app = express()
  .use files Path.join directory

do ->

  server = await app.listen 3000
  browser = await puppeteer.launch()
  page = await browser.newPage()

  print await test "Carbon",  [

    test "loads", ->

      await page.goto "http://localhost:3000"

      content = await page.evaluate ->
        document
          .querySelector "p"
          .textContent

      assert.equal content, "Hello, world!"
  ]

  await browser.close()
  server.close()

  process.exit if success then 0 else 1
