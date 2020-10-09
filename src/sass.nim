# sass
# Copyright Dominik Picheta


## A wrapper for the libsass library.
##
## Options
## -------
##
## * precision - Used to determine how many digits after the decimal
##               will be allowed.
##
## * outputStyle - The output format and style.
##
## * includePaths - A list of include paths.

import os

import sass/libsass

export OutputStyle

type
  SassException* = object of Exception

proc strdup(str: cstring): cstring {.header: "<string.h>", importc.}

proc setOptions*(ctx: ptr Context | ptr DataContext | ptr FileContext,
                 precision: cint, outputStyle: OutputStyle,
                 includePaths: seq[string], outputPath: string) =
  let opts = ctx.getOptions()
  opts.setPrecision(precision)
  opts.setOutputStyle(outputStyle)
  for p in includePaths:
    let allocatedData = strdup(p)
    opts.pushIncludePath(allocatedData)
  if outputPath.len > 0:
    opts.setOutputPath(outputPath)

proc compile*(data: string, precision: int = 5,
              outputStyle: OutputStyle = Nested,
              includePaths: seq[string] = @[]): string =
  ## Compiles a Sass/SCSS string to CSS.
  let allocatedData = strdup(data)
  let dataCtx = makeDataContext(allocatedData)
  defer:
    dataCtx.delete()

  setOptions(dataCtx, precision.cint, outputStyle, includePaths, "")
  let ctx = dataCtx.getContext()
  if dataCtx.compile() != 0:
    raise newException(SassException, $ctx.get_error_text())

  result = $ctx.getOutputString()


proc compileFile*(filename: string, outputPath = "",
                  precision: int = 5, outputStyle: OutputStyle = Nested,
                  includePaths: seq[string] = @[]) =
  let allocatedFilename = strdup(filename)
  let fileCtx = makeFileContext(allocatedFilename)
  defer:
    fileCtx.delete()

  setOptions(fileCtx, precision.cint, outputStyle, includePaths, outputPath)
  let ctx = fileCtx.getContext()
  if fileCtx.compile() != 0:
    raise newException(SassException, $ctx.get_error_text())

  let outputPath =
    if outputPath.len == 0:
      filename.changeFileExt("css")
    else:
      outputPath
  writeFile(outputPath, $ctx.getOutputString())
