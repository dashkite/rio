fs = require "fs"
{task,src,dest,series,parallel} = require "gulp"
del = require "del"
coffeescript = require "coffeescript"
coffee = require "gulp-coffee"

# package.json object
$package = do ->
  fs = require "fs"
  JSON.parse fs.readFileSync "package.json"

# Helper to run external programs
run = do ->
  {exec} = require('child_process')
  (command) ->
    new Promise (yay, nay) ->
      exec command, (error, stdout, stderr) ->
        if !error?
          yay [stdout, stderr]
        else
          nay error

# print output
print = ([stdout, stderr]) ->
  process.stdout.write stdout if stdout.length > 0
  process.stderr.write stderr if stderr.length > 0

task "clean", -> del "build"
task "npm", ->
  src "lib/**/*.coffee", sourcemaps: true
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
  .pipe dest "build/lib"

# Tag a release
task "git:tag", ->
  {version} = $package
  await run "git tag -am #{version} #{version}"
  await run "git push --tags"
