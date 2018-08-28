import {createTree, html} from "diffhtml"

# make it easy to process HTML string directly
HTML = parse: (s) -> [ html? s ]

el = (name) ->
  (rest...) -> createTree? name, rest...

do ->
  # source: https://dev.w3.org/html5/html-author/#conforming-elements
  tags = "a abbr address area article aside audio b base bb bdo blockquote body
  br button canvas caption cite code col colgroup command datagrid datalist dd
  del details dfn dialog div dl dt em embed fieldset figure footer form h1 h2 h3
  h4 h5 h6 head header hr html i iframe img input ins kbd label legend li link
  main map mark menu meta meter nav noscript object ol optgroup option output p
  param pre progress q rp rt ruby samp script section select slot small source
  span strong style sub sup table tbody td textarea tfoot th thead time title tr
  ul var video".split " "

  HTML[tag] = el tag for tag in tags

HTML.stylesheet = (url) ->
  HTML.link rel: "stylesheet", href: url

SVG = {}

do ->
  # source: https://www.w3.org/TR/SVG2/eltindex.html
  tags = "a altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion
  animateTransform animation audio canvas circle clipPath color-profile cursor
  defs desc discard ellipse feBlend feColorMatrix feComponentTransfer
  feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap
  feDistantLight feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR
  feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight
  feSpecularLighting feSpotLight feTile feTurbulence filter font font-face
  font-face-format font-face-name font-face-src font-face-uri foreignObject g
  glyph glyphRef handler hatch hatchpath hkern iframe image line linearGradient
  listener marker mask mesh meshgradient meshpatch meshrow metadata
  missing-glyph mpath path pattern polygon polyline prefetch radialGradient rect
  script set solidColor solidcolor stop style svg switch symbol tbreak text
  textArea textPath title tref tspan unknown use video view vkern".split " "

  SVG[tag] = el tag for tag in tags

export {el, HTML, SVG}
