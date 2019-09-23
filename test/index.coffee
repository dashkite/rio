import {print, test, success} from "amen"
import puppeteer from "puppeteer"

do ->

  browser = await puppeteer.launch()
  page = await browser.newPage()

  print await test "Panda Play",  [

    test "Play loads as a module", ->
      await page.addScriptTag
        path: "./build/web/src/index.js"
        type: "module"


  ]

  await browser.close()

  process.exit if success then 0 else 1
