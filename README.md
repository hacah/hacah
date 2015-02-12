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

## Fonts
By default Helvetica Neue is used to match the Cards Against Humanity look as closely as possible. The font can be bought [here](http://www.linotype.com/1266/neuehelvetica-family.html). The Bold (75) and Heavy (85) typefaces are used.

Currently no other font is supported. If you do not own the font you have to modify the script yourself.
