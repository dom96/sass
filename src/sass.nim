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
from strutils import spaces

export OutputStyle

type
  SassException* = object of CatchableError

proc strdup(str: cstring): cstring {.header: "<string.h>", importc.}

proc setOptions*(ctx: ptr Context | ptr DataContext | ptr FileContext,
                 precision: cint, outputStyle: OutputStyle,
                 includePaths: seq[string], outputPath = "",
                 indent = 2, sourceMapEmbed,
                 sourceMapContents, sourceMapFile = false): ptr Options {.discardable.} =
  let opts = ctx.getOptions()
  opts.setPrecision(precision)
  opts.setOutputStyle(outputStyle)  # Output style: Nested, Expanded, Compact, Compressed
  opts.setIndent(indent.spaces().cstring)   # Base indentation (default 2)
  var toSourceMapFile: bool
  if sourceMapEmbed:
    opts.setSourceMapEmbed(true)
    opts.setSourceMapContents(sourceMapContents)
  elif sourceMapFile:
    toSourceMapFile = true

  for p in includePaths:
    let allocatedData = strdup(p)
    opts.pushIncludePath(allocatedData)
  if outputPath.len > 0:
    opts.setOutputPath(outputPath)
    if toSourceMapFile:
      opts.setSourceMapFileUrls(true)
      opts.setSourceMapFile(outputPath.changeFileExt(".css.map").cstring)
      opts.setSourceMapContents(sourceMapContents)
  result = opts

template setContext(dataFile: string, isDataCtx: static bool = false) =
  let allocatedData = strdup(dataFile)
  when isDataCtx:
    fdCtx = makeDataContext(allocatedData)
  else:
    fdCtx = makeFileContext(allocatedData)
  defer:
    fdCtx.delete()

template toCss(): untyped =
  let ctx = fdCtx.getContext()
  if fdCtx.compile() != 0:
    raise newException(SassException, $ctx.get_error_text())
  when declared outputPath:
    let outputPath =
      if outputPath.len == 0:
        filename.changeFileExt("css")
      else:
        outputPath
    writeFile(outputPath, $ctx.getOutputString())
    if opts.getSourceMapFile.len != 0:
      writeFile($opts.getSourceMapFile, $getSourceMapString(ctx))
  else:
    $ctx.getOutputString()
#
# Public API
#
proc compileSass*(data: string, precision: int = 5,
                  outputStyle: OutputStyle = Nested,
                  includePaths: seq[string] = @[], indent = 2,
                  sourceMapEmbed, sourceMapContents = false): string =
  ## Compiles a `SASS` string and returns the `CSS` output
  var fdCtx: ptr DataContext
  setContext data, true
  setOptions(fdCtx, precision.cint, outputStyle, includePaths,
            "", indent, sourceMapEmbed, sourceMapContents)
            .setIsIndentedSyntaxSrc(true)
  toCss

proc compile*(data: string, precision: int = 5,
              outputStyle: OutputStyle = Nested,
              includePaths: seq[string] = @[], indent = 2,
              sourceMapEmbed, sourceMapContents, fromSass = false): string =
  ## Compiles a SCSS string to CSS.
  var fdCtx: ptr DataContext
  setContext data, true
  setOptions(fdCtx, precision.cint, outputStyle, includePaths,
            "", indent, sourceMapEmbed, sourceMapContents)
  toCss

proc compileFile*(filename: string, outputPath = "",
                  precision: int = 5, outputStyle: OutputStyle = Nested,
                  includePaths: seq[string] = @[], indent = 2,
                  sourceMapEmbed, sourceMapFile, sourceMapContents = false) =
  ## Compiles a Sass/SCSS file to CSS.
  var fdCtx: ptr FileContext
  setContext filename
  let opts = setOptions(fdCtx, precision.cint, outputStyle,
              includePaths, outputPath, indent,
              sourceMapEmbed, sourceMapContents, sourceMapFile)
  toCss