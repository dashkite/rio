import {promise, follow} from "fairmont-helpers"

# create a reactor that can enqueue values
queue = ->

  done = false
  pending = []
  resolved = []

  end = ->
    done = true
    pending = resolved = undefined

  enqueue = (value) ->
    unless done
      if pending.length == 0
        resolved.push {done, value}
      else
        {resolve, reject} = pending.shift()
        follow value
        .then (value) -> resolve {done, value}
        .catch reject

  dequeue = ->
    unless done
      if resolved.length == 0
        promise (resolve, reject) -> pending.push {resolve, reject}
      else
        resolved.shift()
    else
      {done}


  {
    enqueue
    dequeue
    end
    next: dequeue
    [Symbol.asyncIterator]: -> @
  }

export {queue}
