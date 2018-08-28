fs = require "fs"
{task,src,dest,series,parallel, watch} = require "gulp"
del = require "del"
coffee = require "coffeescript"
thru = require "through2"

tee = (f) ->
  thru.obj (file, encoding, callback) ->
    await f file, encoding
    callback null, file

pluck = (key, f) ->
  tee (file) -> f file[key]

extension = (extension) ->
  tee (file) ->
    file.extname = extension

content = (f) ->
  tee (file, encoding) ->
    file.contents = Buffer.from await f (file.contents.toString encoding), file

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
task "build", ->
  src "lib/**/*.coffee" #, sourcemaps: true
  .pipe content (code, file) ->
    coffee.compile code,
      bare: true
      inlineMap: true
      filename: file.relative
      transpile:
        presets: [[ "stage-3" ]]
      #   [
      #     "env",
      #       targets:
      #         browsers: [ "chrome >= 67" ]
      #       modules: false
      #   ]
      # ]
      #       bare: false,
  .pipe extension ".js"
  .pipe dest "build/lib"

# Tag a release
task "git:tag", ->
  {version} = $package
  await run "git tag -am #{version} #{version}"
  await run "git push --tags"

task "watch", ->
  watch [ "lib/**/*.coffee" ], series (task "clean"), (task "build")
