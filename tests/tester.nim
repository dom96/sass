import unittest, strutils, os
import sass

let strSass = """
body
  div
    color: red
"""

let strScss = """
body {
  div {
    color: red
  }
}
"""

test "can compile string (Scss)":
  check "color: red;" in compile(strScss)

test "can compile w/ custom indent (Scss)":
  let css = compile(strScss, indent = 4, outputStyle = Expanded)
  let lines = css.splitLines()
  check lines.len == 4
  check lines[1][0..3] == spaces(4)

test "can compile string (Sass)":
  check "color: red;" in compileSass(strSass)

test "can compile w/ custom indent (Sass)":
  let css = compileSass(strSass, indent = 4, outputStyle = Expanded)
  let lines = css.splitLines()
  check lines.len == 4
  check lines[1][0..3] == spaces(4)

test "can embed sourceMappingUrl as data uri":
  let css = compile(strScss, sourceMapEmbed = true, sourceMapContents = true)
  check "sourceMappingURL=data:application/json" in css

test "can set options":
  let css = compile(strScss, outputStyle=Compact)
  check css.splitLines().len == 2

test "can compile file (Sass)":
  compileFile("tests/basic.sass", "tests/basic.css")
  check fileExists("tests/basic.css")

test "can compile file (SCSS)":
  compileFile("tests/basic.scss", "tests/basic.css")
  check fileExists("tests/basic.css")

test "can compile file with source map":
  compileFile("tests/basic.scss", "tests/basic.css", sourceMapFile = true)
  check fileExists("tests/basic.css.map")

test "can report errors":
  expect SassException:
    compileFile("tests/error.scss")