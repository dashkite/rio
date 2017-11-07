style
  include:stylus ./index.styl

ul
  each tab in tabs
    li(class=(selected == tab.name ? "selected" : ""))
      slot(name=tab.name)
