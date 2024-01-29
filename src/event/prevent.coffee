import { peek } from "@dashkite/katana/sync"

prevent = peek ( event ) -> event.preventDefault()

export { prevent }
