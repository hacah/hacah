# Have a Card Against Humanity

Use this script to generate your own cards for the popular card game [Cards Against Humanity](http://cardsagainsthumanity.com).

## Usage
Write your own cards into a YAML file. See `sample.yaml` for examples.
Run the script to generate a LaTeX document with your cards.
```
ruby hacah.rb sample.yaml
```
This will produce `sample.tex`. As special font settings are required use XeLaTeX to build this file.
```
xelatex sample.tex
```

Run `ruby hacah.rb --help` for more information.

### Processing multiple files
To organise your collection of cards you can store them in different files. Each file can contain black and/or white cards. To process multiple files at once pass all of them to hacah.
```
ruby hacah.rb file1.yaml file2.yaml
```
This will produce an output file for each input file, i.e. `file.tex` for `file.yaml`. To merge all inputs into a single output file specify an output filename using the `--output` parameter.
```
ruby hacah.rb --output cards.tex collection1.yaml collection2.yaml
```

## Fonts
By default Helvetica Neue is used to match the Cards Against Humanity look as closely as possible. The font can be bought [here](http://www.linotype.com/1266/neuehelvetica-family.html). The Bold (75) and Heavy (85) typefaces are used.

Currently no other font is supported. If you do not own the font you have to modify the script yourself.
