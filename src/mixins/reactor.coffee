import {pipe, tee, spread} from "panda-garden"
import {follow} from "panda-parchment"
import {property, method} from "./helpers"

autorender = tee (type) ->
  type.on change: -> @render()
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
      # TODO: scope to local
      @on change: -> target.value = @value

]

export {autorender, reactor}
