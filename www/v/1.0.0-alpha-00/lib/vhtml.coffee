createTree = html = null

do ->
  [{createTree, html}] = await require [
    "//diffhtml.org/master/diffhtml/dist/diffhtml.min.js"
  ]

# make it easy to process HTML string directly
HTML = parse: (s) -> [ html? s ]

el = (name) ->
  (rest...) -> createTree? name, rest...

# source: https://dev.w3.org/html5/html-author/#conforming-elements
tags = "a abbr address area article aside audio b base bb bdo blockquote body
br button canvas caption cite code col colgroup command datagrid datalist dd
del details dfn dialog div dl dt em embed fieldset figure footer form h1 h2 h3
h4 h5 h6 head header hr html i iframe img input ins kbd label legend li link
map mark menu meta meter nav noscript object ol optgroup option output p param
pre progress q rp rt ruby samp script section select slot small source span
strong style sub sup table tbody td textarea tfoot th thead time title tr ul
var video".split " "

HTML[tag] = el tag for tag in tags


HTML.stylesheet = (url) ->
  HTML.link rel: "stylesheet", href: url

export default HTML
