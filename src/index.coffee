export * from "./handle"
export * from "./connect"
export * from "./event"
export * from "./actions"

import * as Mixins from "./mixins"

{connect, diff, tag, mixin} = Mixins

Metal =
  connect: Mixins._connect

export {
  Metal
  connect
  diff
  tag
  mixin
}
