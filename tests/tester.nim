import unittest, strutils, os

import sass

test "can compile string":
  check "color: red;" in compile("body { div { color: red; } }")

test "can set options":
  let css = compile("body { div { color: red; } }", outputStyle=Compact)
  check css.splitLines().len == 2

test "can compile file (Sass)":
  compileFile("tests/basic.sass", "tests/basic.css")
  check fileExists("tests/basic.css")

test "can compile file (SCSS)":
  compileFile("tests/basic.scss", "tests/basic.css")
  check fileExists("tests/basic.css")

test "can report errors":
  expect SassException:
    compileFile("tests/error.scss")