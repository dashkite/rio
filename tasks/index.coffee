import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"

preset t

t.after "build", [ "pug:with-import-map" ]
