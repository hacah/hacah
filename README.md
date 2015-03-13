# Have a Card Against Humanity

Use this script to generate your own cards for the popular card game [Cards Against Humanity](http://cardsagainsthumanity.com).

## Usage
Write your own cards into a YAML file. See [sample.yaml](sample.yaml) for examples.
Run the script to generate a LaTeX document with your cards.
```
ruby hacah.rb sample.yaml
```
This will produce `sample.tex`. As special [fonts](#fonts) are required use XeLaTeX to build this file.
```
xelatex sample.tex
```
Use the parameter `--no-black` or `--no-white` to restrict processing to white or black files.

To get correct hyphenation you can specify the language for the [babel](http://www.ctan.org/pkg/babel) package using the `--language` parameter.

Run `ruby hacah.rb --help` for more information.

### Processing multiple files
To organise your collections of cards you can store them in different files. Each file can contain one collection of black and/or white cards. Each collection can have an optional name and an optional *edition* that is printed on the card. To process multiple files at once pass all of them to hacah.
```
ruby hacah.rb file1.yaml file2.yaml
```
This will produce an output file for each input file, i.e. `file.tex` for `file.yaml`. To merge all inputs into a single output file specify an output filename using the `--output` parameter.
```
ruby hacah.rb --output cards.tex collection1.yaml collection2.yaml
```

## Card file format
Card information for hacah is stored in YAML files. Take a look at [sample.yaml](sample.yaml) to see how the files are structured.
You can store a list of black cards (`black-cards`) and/or white cards (`white-cards`) in the file. Each entry in the lists represents a card. Each card has the following parameters
* `text` (*required*) — Card text.
* `font` (*optional*) — Font size. Supported font sizes are 10, 11, 12 and 13. Default size is 13.
* `pick` (*optional*) — Numer of cards to pick (black cards only).
* `draw` (*optional*) — Numer of cards to draw (black cards only).

To use custom line breaks add multi line text.
```yaml
  - text: |
          Multi
          line
          text
```

Use an underscore to add a placeholder to the card text. Append the length of the placeholder in *ex* to the underscore.
```yaml
  - text: _4.2 is better than _8.`
```
To get a literal underscore do not follow it by a number. ;)
*If you really need a literal underscore followed by a number (why???) use two underscores instead of one.*

If your collection has an edition entry it will be printed inside the small cards of the logo. You can use this to sort out different collections if you want to. Please keep in mind that there is only space for a maximum of approximately two by two letters, so keep your edition codes short.

### Caveats
* If your text contains a colon (:) you have to use the multi line format, even if it is just a single line.
* If your text starts with a quotation mark (' or ") you have to use the multi line format.

## Fonts
By default Helvetica Neue is used to match the Cards Against Humanity look as closely as possible. The font can be bought [here](http://www.linotype.com/1266/neuehelvetica-family.html). The Bold (75) and Heavy (85) typefaces are used.

Currently no other font is supported. If you do not own the font you have to modify the script yourself.

## Printing
To prepare your cards for printing you can use [PDFjam](http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/).
```
pdfjam --paper a4paper --nup 4x5 --noautoscale true --frame true cards.pdf
```
