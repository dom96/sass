# Package

version       = "0.1.0"
author        = "Dominik Picheta"
description   = "A wrapper for the libsass library."
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.18.0"

when defined(nimdistros):
  import distros
  if detectOs(Ubuntu):
    foreignDep "libsass-dev"
  else:
    foreignDep "libsass"

task test, "Runs tester":
  exec "nim c -r tests/tester"