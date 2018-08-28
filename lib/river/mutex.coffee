import {tee} from "fairmont-core"
import {promise} from "fairmont-helpers"

mutex = ->

  # This will be set to the Promise of whomever
  # is currently last in line.
  pending = undefined

  # This function returns an unlock function that
  # must be called when you're ready to release
  # the lock. This is only used internally to
  # make sure no one ever forgets to do that. :)
  lock = ->

    _unlock = undefined

    # First thing we do is get in line.
    current = pending

    # Next, we set up a promise for whomever comes
    # next. Within that promise, we'll set up the
    # unlock function which will resolve it.
    pending = do (_pending = undefined) ->

      # We keep track of the promise so we can
      # compare it when we're ready to release the
      # lock in case there's no one else in line.
      # That way, we avoid unnecessary awaits.
      _pending = promise (resolve) ->

        # The unlock function that we'll return.
        # Always returns whatever is passed to it (tee),
        # to make it easy to call it with the results
        # of whatever you needed the lock for.
        _unlock = tee ->
          # Clear pending if no one is in line, that is,
          # if the promise we're resolving is still the
          # last one pending ...
          if _pending == pending
            pending = undefined
          # Resolve the promise.
          resolve()

    # With pending set, we can wait to acquire the lock,
    # presuming there is one.
    await current if current?

    # Finally, return the unlock function we defined within
    # locking promise so the lock can be, well, unlocked. :)
    _unlock

  # This is the actual function we'll return to the caller.
  # They can avoid worrying about lock/unlock and just pass
  # in a function and we take care of the lock/unlock and
  # return the results of whatever that function returned.
  (f) ->
    unlock = await lock()
    unlock await f()

export {mutex}
