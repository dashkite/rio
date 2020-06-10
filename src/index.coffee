export * from "./handle"
export * from "./event"
export * from "./actions"
export * from "./mixin"

import * as Mixins from "./mixins"
import * as Connect from "./connect"

{connect, diff, tag} = Mixins
{describe, event, observe, shadow} = Connect

Metal =

  connect: Mixins._connect

  describe: Connect._describe
  event: Connect._event
  observe: Connect._observe
  shadow: Connect._shadow

export {
  Metal
  connect
  diff
  tag
  describe
  event
  observe
  shadow
}
