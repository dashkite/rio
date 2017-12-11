gulp = require "gulp"
del = require "del"
footer = require "gulp-footer"
pug = require "gulp-pug"
stylus = require "gulp-stylus"
coffeescript = require "coffeescript"
coffee = require "gulp-coffee"
webserver = require "gulp-webserver"
webpack = require "webpack"
path = require "path"

gulp.task "js", ->
  new Promise (yay, nay) ->
    webpack
      entry: "./www/demos/markdown-editor/index.coffee"
      output:
        path: path.resolve "build/www/demos/markdown-editor"
        filename: "index.js"
      module:
        rules: [
          test: /\.coffee$/
          use: [ 'coffee-loader' ]
        ,
          test: /\.styl$/
          use: [ 'raw-loader', 'stylus-loader' ]
        ]
      resolve:
        modules: [
          path.resolve "lib"
          "node_modules"
        ]
        extensions: [ ".js", ".json", ".coffee" ]
      (error, result) ->
        console.error result.toString colors: true
        if error? || result.hasErrors()
          nay error
        else
          yay()

gulp.task "server", ->
  gulp
  .src "build/www"
  .pipe webserver
      livereload: true
      port: 8000
      extensions: [ "html" ]

gulp.task "clean", ->
  del "build"

gulp.task "html", ->
  gulp
  .src [ "www/**/*.pug" ]
  .pipe pug {}
  .pipe gulp.dest "build/www"

gulp.task "css", ->
  gulp
  .src "www/**/*.styl"
  .pipe stylus()
  .pipe gulp.dest "build/www"

gulp.task "images", ->
  gulp
  .src [ "www/images/**/*" ]
  .pipe gulp.dest "build/www/images"


# watch doesn't take a task name for some reason
# so we need to first define this as a function
build = gulp.series "clean",
  gulp.parallel "html", "css", "js", "images"

gulp.task "build", build

gulp.task "watch", ->
  # TODO this isn't picking up changes
  # to the stylus or coffeescript files
  gulp.watch [ "www/**/*", "lib/**/*" ], build

gulp.task "default",
  gulp.series "build",
    gulp.parallel "watch", "server"
