import { peek } from "@dashkite/katana/sync"

stop = peek ( event ) -> event.stopPropagation()

export { stop }
