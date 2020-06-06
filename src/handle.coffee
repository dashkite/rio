import {readonly} from "./helpers"

class Handle
  constructor: (@dom) ->

  readonly @::, root: -> @shadow ? @dom

export {Handle}
