export * from "./handle"
export * from "./event"
export * from "./mixin"

import * as Mixins from "./mixins"
import * as Connect from "./connect"
import * as Actions from "./actions"
import * as Event from "./event"

{connect, diff, initialize, tag} = Mixins
{describe, event, observe, ready, shadow, sheet} = Connect
{assign, bind, description, discard, form, render} = Actions
{intercept, matches, prevent, stop} = Event

Metal =

  connect: Mixins._connect
  initialize: Mixins._initialize

  describe: Connect._describe
  event: Connect._event
  observe: Connect._observe
  shadow: Connect._shadow
  sheet: Connect._sheet

  assign: Actions._assign
  bind: Actions._assign
  description: Actions._description
  form: Actions._form

  intercept: Event._intercept
  matches: Event._matches

export {

  Metal

  connect
  diff
  initialize
  tag

  describe
  event
  observe
  shadow
  sheet

  ready
  assign
  bind
  description
  form
  render

  intercept
  matches
  prevent
  stop

}
