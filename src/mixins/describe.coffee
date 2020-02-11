import {ready} from "./phased"
import {pipe, getter} from "./helpers"

describe = pipe [

  # define a getter that returns an ordinary object
  getter description: -> Object.assign {}, @dom.dataset

  # dispatch 'describe' event when we change an attribute
  ready ->
    new MutationObserver (=> @dispatch "describe")
    .observe @dom, attributes: true

]

export {describe}
