import {ready} from "./phased"
import {pipe} from "./helpers"
import {events, local} from "./evented"

resource = (loader) ->

  pipe [

    ready -> @value = await loader.apply @

    events
      activate: local loader
      describe: local loader

  ]

export {resource}
