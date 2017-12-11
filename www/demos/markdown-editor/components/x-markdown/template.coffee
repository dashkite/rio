import HTML from "panda-play"
import css from "./index.styl"

{style, div, parse} = HTML

template = ({output}) -> [
  style css
  div parse output
]

export {template}
