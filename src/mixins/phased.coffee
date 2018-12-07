import {w, bind, promise} from "panda-parchment"
import {apply, pipe, spread, tee} from "panda-garden"
import {go, map, into, wait} from "panda-river-esm"
import {$methods, methods} from "./helpers"

phased = (spread pipe) [

  $methods
    connect: (f) -> (@_connect ?= []).push f
    prepare: (f) -> (@_prepare ?= []).push f
    ready: (f) -> (@_ready ?= []).push f

  methods
    connect: ->
      @ready ?= promise (resolve) =>
        await go [
          w "connect prepare ready"
          map (phase) => @constructor["_#{phase}"]
          # map into [
          #   map bind @
          #   map apply
          # ]
          map (handlers) =>
            if handlers?
              for handler in handlers
                apply bind handler, @
            else
              []
          wait map (promises) -> Promise.all promises
        ]
        resolve true
]

connect = (handler) -> tee (type) -> type.connect handlers
prepare = (handler) -> tee (type) -> type.prepare handler
ready = (handler) -> tee (type) -> type.ready handler

export {phased, connect, prepare, ready}
