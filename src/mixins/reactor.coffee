import {pipe, tee, spread} from "panda-garden"
import {follow} from "panda-parchment"
import {property, method} from "./helpers"
import {local} from "./evented"

autorender = tee (type) ->
  type.on change: local -> @render()
  type.ready -> @render()

reactor = (spread pipe) [

  property
    value:
      get: -> @_value
      set: (value) ->
        @_value = value
        @dispatch "change"
        @_value

  method
    pipe: (target) ->
      @on change: local -> target.value = @value

]

export {autorender, reactor}
