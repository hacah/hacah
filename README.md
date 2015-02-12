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

## Fonts
By default Helvetica Neue is used to match the Cards Against Humanity look as closely as possible. The font can be bought [here](http://www.linotype.com/1266/neuehelvetica-family.html). The Bold (75) and Heavy (85) typefaces are used.

Currently no other font is supported. If you do not own the font you have to modify the script yourself.
