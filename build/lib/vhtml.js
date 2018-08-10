var HTML, SVG, el;

import { createTree, html } from "diffhtml";

// make it easy to process HTML string directly
HTML = {
  parse: function (s) {
    return [typeof html === "function" ? html(s) : void 0];
  }
};

el = function (name) {
  return function (...rest) {
    return typeof createTree === "function" ? createTree(name, ...rest) : void 0;
  };
};

(function () {
  var i, len, results, tag, tags;
  // source: https://dev.w3.org/html5/html-author/#conforming-elements
  tags = "a abbr address area article aside audio b base bb bdo blockquote body br button canvas caption cite code col colgroup command datagrid datalist dd del details dfn dialog div dl dt em embed fieldset figure footer form h1 h2 h3 h4 h5 h6 head header hr html i iframe img input ins kbd label legend li link map mark menu meta meter nav noscript object ol optgroup option output p param pre progress q rp rt ruby samp script section select slot small source span strong style sub sup table tbody td textarea tfoot th thead time title tr ul var video".split(" ");
  results = [];
  for (i = 0, len = tags.length; i < len; i++) {
    tag = tags[i];
    results.push(HTML[tag] = el(tag));
  }
  return results;
})();

HTML.stylesheet = function (url) {
  return HTML.link({
    rel: "stylesheet",
    href: url
  });
};

SVG = {};

(function () {
  var i, len, results, tag, tags;
  // source: https://www.w3.org/TR/SVG2/eltindex.html
  tags = "a altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion animateTransform animation audio canvas circle clipPath color-profile cursor defs desc discard ellipse feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting feDisplacementMap feDistantLight feDropShadow feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting feSpotLight feTile feTurbulence filter font font-face font-face-format font-face-name font-face-src font-face-uri foreignObject g glyph glyphRef handler hatch hatchpath hkern iframe image line linearGradient listener marker mask mesh meshgradient meshpatch meshrow metadata missing-glyph mpath path pattern polygon polyline prefetch radialGradient rect script set solidColor solidcolor stop style svg switch symbol tbreak text textArea textPath title tref tspan unknown use video view vkern".split(" ");
  results = [];
  for (i = 0, len = tags.length; i < len; i++) {
    tag = tags[i];
    results.push(SVG[tag] = el(tag));
  }
  return results;
})();

export { el, HTML, SVG };