gulp = require "gulp"
del = require "del"
pug = require "gulp-pug"
stylus = require "gulp-stylus"
coffeescript = require "coffeescript"
coffee = require "gulp-coffee"
webserver = require "gulp-webserver"
webpack = require "webpack"
path = require "path"

gulp.task "npm:clean", -> del "build/npm"
gulp.task "npm:js", ->
  gulp
  .src "lib/**/*.coffee", sourcemaps: true
  .pipe coffee
    coffee: coffeescript
    transpile:
      presets: [
        [
          "env",
            targets:
              browsers: [
                "Chrome >= 62"
                "ChromeAndroid >= 61"
                "Safari >= 11"
                "iOS >= 11"
              ]
            modules: false
          ]
        ]
  .pipe gulp.dest "build/npm/lib"

gulp.task "www:js", ->
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
          # path.resolve "lib"
          "node_modules"
        ]
        extensions: [ ".js", ".json", ".coffee" ]
      (error, result) ->
        console.error result.toString colors: true
        if error? || result.hasErrors()
          nay error
        else
          yay()

gulp.task "www:server", ->
  gulp
  .src "build/www"
  .pipe webserver
      livereload: true
      port: 8000
      extensions: [ "html" ]

gulp.task "www:clean", ->
  del "build/www"

gulp.task "www:html", ->
  gulp
  .src [ "www/**/*.pug" ]
  .pipe pug {}
  .pipe gulp.dest "build/www"

gulp.task "www:css", ->
  gulp
  .src "www/**/*.styl"
  .pipe stylus()
  .pipe gulp.dest "build/www"

gulp.task "www:images", ->
  gulp
  .src [ "www/images/**/*" ]
  .pipe gulp.dest "build/www/images"


gulp.task "www:build",
  gulp.series "www:clean",
    gulp.parallel "www:html", "www:css", "www:js", "www:images"

gulp.task "www:watch", ->
  gulp.watch [ "www/**/*", "lib/**/*", "./*" ], gulp.task "www:build"

gulp.task "default",
  gulp.series "www:build",
    gulp.parallel "www:watch", "www:server"
