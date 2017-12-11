import HTML from "panda-play"
import css from "./index.styl"

{style, textarea} = HTML

template = ({value}) -> [
  style css
  textarea value
]

export {template}
