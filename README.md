# sass

**sass** provides a Sass/SCSS to CSS compiler for [Nim](https://nim-lang.org) through bindings to [`libsass`](https://github.com/sass/libsass/).

**[API Documentation](https://nimble.directory/docs/sass)** ·
**[GitHub Repo](https://github.com/dom96/sass)**

## Installation

Add this to your application's .nimble file:

```nim
requires "sass"
```

or to install globally run:

```
nimble install sass
```

## Usage

```nim
import sass

# Compile a Sass/SCSS file:
compileFile("style.scss")

# Compile a Sass/SCSS file with options:
compileFile("style.sass", outputPath="style.css", includePaths: @["includes"])

# Compile a Sass/SCSS string:
let css = compile("body { div { color: red; } }")
```

## Contributing

1. Fork it ( https://github.com/dom96/sass/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT