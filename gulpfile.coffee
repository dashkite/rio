gulp = require "gulp"
del = require "del"
footer = require "gulp-footer"
pug = require "gulp-pug"
stylus = require "gulp-stylus"
coffeescript = require "coffeescript"
coffee = require "gulp-coffee"
webserver = require "gulp-webserver"

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
  .src [ "www/**/*.pug", "!www/**/components/**" ]
  .pipe pug {}
  .pipe gulp.dest "build"

gulp.task "components", ->
  gulp
  .src [ "www/**/components/**/*.pug" ]
  .pipe pug
    client: true
    filters:
      coffee: (text, options) ->
        coffeescript.compile text, bare: true
  .pipe footer "export { template };"
  .pipe gulp.dest "build"

gulp.task "css", ->
  gulp
  .src "www/**/*.styl"
  .pipe stylus()
  .pipe gulp.dest "build"

gulp.task "js", ->
  gulp
  .src "www/**/*.coffee", sourcemaps: true
  .pipe coffee
    coffee: coffeescript
    # TODO: can we replace WC polyfill with this?
    # TODO: import w/o relying on bundle?
    # transpile:
    #   presets: [[ "env", targets: browsers: [ "last 2 versions" ]]]
  .pipe gulp.dest "build"

gulp.task "images", ->
  gulp
  .src [ "www/images/**/*" ]
  .pipe gulp.dest "build/images"


# watch doesn't take a task name for some reason
# so we need to first define this as a function
build = gulp.series "clean",
  gulp.parallel "html", "css", "js", "images", "components"

gulp.task "build", build

gulp.task "watch", ->
  # TODO this isn't picking up changes
  # to the stylus or coffeescript files
  gulp.watch [ "www/**/*" ], build

gulp.task "default",
  gulp.series "build",
    gulp.parallel "watch", "server"
