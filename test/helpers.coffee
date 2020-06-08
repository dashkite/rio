import Path from "path"
import puppeteer from "puppeteer"
import webpack from "webpack"
import express from "express"
import files from "express-static"
import Pug from "pug"
import {wrap, flow} from "@pandastrike/garden"
import {collect, tee, wait} from "panda-river"
import {rmr, mkdirp} from "panda-quill"
p9k = require "panda-9000"

bundle = (source, build) ->
  bundler = webpack
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

  bundler.watch {}, (error) ->
    if error? then console.error error

clean = (build) ->
  await rmr build
  await mkdirp "0777", "build"

pug = (source, build) ->
  await do flow [
    wrap p9k.glob "**/*.pug", source
    wait tee p9k.read
    tee (context) ->
      context.target.content = Pug.render context.source.content,
        filename: context.source.path
        basedir: source
    tee p9k.extension ".html"
    wait tee p9k.write build
    collect
  ]

server = (root) ->
  app = express()
    .use files root
    .listen 3000

browser = -> puppeteer.launch()

export { bundle, clean, pug, server, browser }
