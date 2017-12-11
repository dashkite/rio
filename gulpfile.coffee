gulp = require "gulp"
del = require "del"
coffeescript = require "coffeescript"
coffee = require "gulp-coffee"

gulp.task "clean", -> del "build"
gulp.task "npm", ->
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
  .pipe gulp.dest "build/lib"
