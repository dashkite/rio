import $ from "/v/1.0.0-alpha-00/lib/dom-helpers.js"

$.ready ->

  console.log "document is ready"

  editor = ($ "x-editor")
  markdown = ($ "x-markdown")

  # TODO: how do we get rid of this?
  # await Promise.all [ editor.isReady, markdown.isReady ]

  $.on editor,
    change: ->
      markdown.data.markdown = editor.data.content

  editor.data.content = """
    # Chapter 1

    It was a dark and stormy night.

    ![](https://pearlsofprofundity.files.wordpress.com/2013/03/snoopy-dark-and-gloomy-night-4.jpg)
    """
