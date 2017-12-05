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
      entry: "./www/v/1.0.0-alpha-00/demos/markdown-editor/index.coffee"
      output:
        path: path.resolve "build/v/1.0.0-alpha-00/demos/markdown-editor"
        filename: "index.js"
      module:
        rules: [
          test: /\.coffee$/
          use: [ 'coffee-loader' ]
        ]
      resolve:
        modules: [
          path.resolve "www/v/1.0.0-alpha-00/lib"
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
  .src "build"
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
  .pipe gulp.dest "build"

gulp.task "css", ->
  gulp
  .src "www/**/*.styl"
  .pipe stylus()
  .pipe gulp.dest "build"

# gulp.task "js", ->
#   gulp
#   .src "www/**/*.coffee", sourcemaps: true
#   .pipe coffee
#     coffee: coffeescript
#     transpile:
#       presets: [
#         [
#           "env",
#             targets:
#               browsers: [
#                 "Chrome >= 62"
#                 "ChromeAndroid >= 61"
#                 "Safari >= 11"
#                 "iOS >= 11"
#               ]
#             modules: "umd"
#           ]
#         ]
#   .pipe gulp.dest "build"

gulp.task "images", ->
  gulp
  .src [ "www/images/**/*" ]
  .pipe gulp.dest "build/images"


# watch doesn't take a task name for some reason
# so we need to first define this as a function
build = gulp.series "clean",
  gulp.parallel "html", "css", "js", "images"

gulp.task "build", build

gulp.task "watch", ->
  # TODO this isn't picking up changes
  # to the stylus or coffeescript files
  gulp.watch [ "www/**/*" ], build

gulp.task "default",
  gulp.series "build",
    gulp.parallel "watch", "server"
