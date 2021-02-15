import Path from "path"
import FS from "fs/promises"
import puppeteer from "puppeteer"
import express from "express"
import files from "express-static"
import Pug from "pug"
import stylus from "stylus"
import Coffee from "coffeescript"
import marked from "marked"
import YAML from "js-yaml"
import {wrap, pipe, flow} from "@pandastrike/garden"
import {tee, wait} from "panda-river"
import {rmr, mkdirp} from "panda-quill"
import * as b from "@dashkite/brick"
import * as k from "@dashkite/katana"
import * as w from "@dashkite/zenpack"

sleep = (ms) ->
  new Promise (resolve) ->
    setTimeout resolve, ms

clean = (build) ->
  await rmr build
  mkdirp "0777", build

# base webpack bundle
bundle = (source, build) ->
  pipe [
    w.config source, build
    w.mainField "main:coffee"
    w.extension ".coffee"
    w.rule
      test: /\.coffee$/
      loader: "coffee-loader"
    w.rule
      test: /\.pug$/
      loader: "pug-loader"
      options:
        root: source
        filters:
          markdown: marked
          stylus: (text) ->
            stylus text
            .include source
            .render()
          yaml: (text) ->
            JSON.stringify YAML.safeLoad text
    w.rule
      test: /\.styl$/
      use: [
        "css-loader"
        "stylus-loader"
      ]
    w.rule
      test: /\.yaml$/
      type: "json"
      loader: "yaml-loader"
    w.alias
      configuration: "#{source}/configuration.coffee"
      helpers: "#{source}/helpers/index.coffee"
      content: "#{source}/content/"
      resources: "#{source}/resources/"
      types: "#{source}/types/"
      templates: "#{source}/templates/"
      pages: "#{source}/pages/index.coffee"
  ]

coffee = (source, build) ->
  do b.start [
    b.glob [ "**/*.coffee" ], source
    b.read
    b.tr ({path}, code) ->
      Coffee.compile code,
        bare: true
        inlineMap: true
        filename: path
        transpile:
          presets: [[
            "@babel/preset-env"
            targets: node: "current"
          ]]
    b.extension ".js"
    b.write build
  ]

pug = (source, build) ->
  do b.start [
    b.glob [ "**/*.pug", "!**/{templates,components,pages}/**/*.pug" ], source
    b.read
    b.tr ({path}, code) ->
      filepath = Path.resolve source, path
      directory = Path.dirname filepath
      Pug.render code,
        filename: filepath
        basedir: source
        filters:
          markdown: marked
          stylus: (text) ->
            stylus text
            .include source
            .include directory
            .render()
          yaml: (text) ->
            JSON.stringify YAML.safeLoad text
    b.extension ".html"
    b.write build
  ]

yaml = (source, build) ->
  do b.start [
    b.glob [ "**/*.yaml" ], source
    b.read
    b.tr ({path}, code) -> JSON.stringify YAML.safeLoad code
    b.extension ".json"
    b.write build
  ]

markdown = (source, build) ->
  do b.start [
    b.glob [ "**/*.md" ], source
    b.read
    b.tr ({path}, code) -> marked code
    b.extension ".html"
    b.write build
  ]

images = (source, build) ->
  do b.start [
    b.glob [ "media/**/*", "!media/-sprites" ], source
    b.copy build
  ]

browser = -> puppeteer.launch()

server = (root) ->
  express()
    .use files root
    .listen()

export {
  clean
  bundle
  coffee
  pug
  yaml
  markdown
  images
  browser
  server
}
