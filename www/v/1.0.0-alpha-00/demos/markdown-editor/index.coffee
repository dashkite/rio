import {Gadget} from "/v/1.0.0-alpha-00/lib/play.js"

document.addEventListener "DOMContentLoaded", ->

  console.log "document is ready"

  # Problem: Gadgets may not be ready
  editor = (Gadget.select "x-editor")
  markdown = (Gadget.select "x-markdown")

  editor.on change: ->
    markdown.value = editor.value

  editor.value = """
    # Chapter 1

    It was a dark and stormy night.

    ![](https://pearlsofprofundity.files.wordpress.com/2013/03/snoopy-dark-and-gloomy-night-4.jpg)
    """
