#!/usr/bin/env ruby

require 'yaml'
# require 'awesome_print'
require 'optparse'

class Card
  attr_accessor :text, :font, :draw, :pick

  def initialize(data)
    @text = data['text'].chomp
    @font = data['font']
    raise "Font size '#{@font}' not supported." unless @font.nil? or (10..13).to_a.include? @font
    @draw = data['draw']
    @pick = data['pick']
  end

  def has_draw?
    not @draw.nil?
  end

  def has_pick?
    not @pick.nil?
  end

  def has_font?
    not @font.nil?
  end

  FontSizes = {
    10 => 15,
    11 => 16,
    12 => 16,
    13 => 18,
  }

  BlankPattern = /(?<!_)_(\d*\.?\d+)/
  BlankTemplate = '\tikz[blank] { \draw (0, 0) -- (\1ex, 0); }'

  def to_tikz
    tikz = ''
    # tikz += '\draw[help lines] (0, 0) grid (5, -5);'
    # background
    tikz += "\\fill[clip] (0, 0) rectangle (5, -5);\n"
    tikz += "\\fill[background] (0, 0) rectangle (5, -5);\n"
    # text area
    # tikz += '\path[fill=white, draw=cah_grey, line width=0.33mm, rounded corners=0.37cm] (0.32, -0.32) rectangle (4.68, -3.32);'
    # CAH logo
    tikz += "\\path[logo card black, rotate around={17:(0.54, -4.59)}] (0.54, -4.59) rectangle +(0.352, 0.352);\n"
    tikz += "\\path[logo card white] (0.61, -4.55) rectangle +(0.352, 0.352);\n"
    tikz += "\\path[logo card white, rotate around={-17:(0.69, -4.537)}] (0.69, -4.537) rectangle +(0.352, 0.352);\n"
    if has_pick?
      tikz += "\\node[logo text] at (1.197, -4.525) {CAH};\n"
    else
      tikz += "\\node[logo text] at (1.197, -4.525) {Cards Against Humanity};\n"
    end
    # card text
    size = @font || 13
    # handle blanks
    text = @text.gsub(BlankPattern, BlankTemplate).gsub('__', '_')
    text = sanitize_for_latex text
    tikz += "\\node[card text, font=\\HelveticaHeavy\\fontsize{#{size}}{#{FontSizes[size]}}\\bfseries] at (0.436, -0.436) {#{text}};"

    if has_pick?
      tikz += "\\node[instruction text] at (4.025, -4.525) {PICK};\n"
      tikz += "\\node[instruction number] at (4.387, -4.533) {#{@pick}};\n"
    end
    if has_draw?
      tikz += "\\node[instruction text] at (4.025, -3.834) {DRAW};\n"
      tikz += "\\node[instruction number] at (4.387, -3.847) {#{@draw}};\n"
    end
    tikz
  end

  private
  def sanitize_for_latex(text)
    text.gsub("\n", "\\\\\\\\").gsub('_', '\_').gsub('%', '\%')
  end
end

CommonPreamble = <<EOF
\\documentclass[tikz]{standalone}
\\usepackage{fontspec}
\\newfontfamily\\HelveticaBold[BoldFont={* 75 Bold}]{Helvetica Neue LT Std}
\\newfontfamily\\HelveticaHeavy[BoldFont={* 85 Heavy}]{Helvetica Neue LT Std}
\\definecolor{cah_grey}{RGB}{35,31,32}
\\tikzset{blank/.style={baseline=0.137em, line width=0.056em}}
EOF

BlackSettings = <<EOF
\\tikzset{background/.style={cah_grey}}
\\tikzset{logo text/.style={anchor=base west, inner sep=0, text=white, font=\\HelveticaBold\\fontsize{5}{5}\\bfseries}}
\\tikzset{card text/.style={anchor=north west, inner sep=0, text=white, text width=4.128cm, align=flush left}}
\\tikzset{logo card black/.style={fill=cah_grey, draw=white, line width=0.1mm}}
\\tikzset{logo card white/.style={fill=white, draw=cah_grey, line width=0.1mm}}
\\tikzset{instruction text/.style={anchor=base east, inner sep=0, text=white, font=\\HelveticaBold\\fontsize{10.5}{10.5}\\bfseries}}
\\tikzset{instruction number/.style={anchor=base, inner sep=0, fill=white, text=cah_grey, font=\\HelveticaBold\\fontsize{12.5}{12.5}\\bfseries, circle, minimum size=0.533cm}}
EOF

WhiteSettings = <<EOF
\\tikzset{background/.style={white}}
\\tikzset{logo text/.style={anchor=base west, inner sep=0, text=cah_grey, font=\\HelveticaBold\\fontsize{5}{5}\\bfseries}}
\\tikzset{card text/.style={anchor=north west, inner sep=0, text=cah_grey, text width=4.128cm, align=flush left}}
\\tikzset{logo card black/.style={fill=cah_grey, draw=cah_grey, line width=0.1mm}}
\\tikzset{logo card white/.style={fill=white, draw=cah_grey, line width=0.1mm}}
EOF

def read_cards io
  card_data = YAML.load io

  return nil unless card_data.is_a? Hash

  black_cards = []
  if card_data.has_key? 'black-cards'
    card_data['black-cards'].each do |data|
      black_cards <<= Card.new data
    end
  end
  # STDERR.puts "Read #{black_cards.length} black cards."

  white_cards = []
  if card_data.has_key? 'white-cards'
    card_data['white-cards'].each do |data|
      white_cards <<= Card.new data
    end
  end
  # STDERR.puts "Read #{white_cards.length} white cards."

  return {
    black: black_cards,
    white: white_cards
  }
end

def write_cards(cards, io, output_black, output_white, language)
  if output_black
    black_tikz = cards[:black].collect { |card| card.to_tikz }
  end
  if output_white
    white_tikz = cards[:white].collect { |card| card.to_tikz }
  end

  io.puts CommonPreamble
  unless language.nil?
    io.puts "\\usepackage[#{language}]{babel}"
  end
  io.puts '\begin{document}'
  if output_black
    io.puts BlackSettings
    black_tikz.each do |t|
      io.puts '\begin{tikzpicture}'
      io.puts t
      io.puts '\end{tikzpicture}'
      io.puts ''
    end
  end
  if output_white
    io.puts WhiteSettings
    white_tikz.each do |t|
      io.puts '\begin{tikzpicture}'
      io.puts t
      io.puts '\end{tikzpicture}'
      io.puts ''
    end
  end
  io.puts '\end{document}'
end

#######################################################################
#                            Main program                             #
#######################################################################

options = {
  :black => true,
  :white => true,
}
option_parser = OptionParser.new do |opts|
  executable_name = File.basename $PROGRAM_NAME
  opts.banner = "Build cards for Cards Agains Humanity

Usage: #{executable_name} [card_data ...]"

  opts.on('-b', '--no-black', 'Don\'t build black cards') do |black|
    options[:black] = black
  end
  opts.on('-w', '--no-white', 'Don\'t build white cards') do |white|
    options[:white] = white
  end
  opts.on('-o file', '--output', 'Output filename') do |file|
    options[:output] = file
  end
  opts.on('-l lang', '--language', 'Set babel language for hyphenation') do |lang|
    options[:language] = lang
  end
end

option_parser.parse!
if ARGV.empty?
  puts option_parser.banner
  exit 1
  # # Use as pipe
  # cards = read_cards STDIN
  # if cards.nil?
  #   STDERR.puts 'Error parsing input.'
  #   exit 1
  # end
  # if options.has_key? 'output'
  #   write_cards cards, STDOUT, options[:black], options[:white]
  # end
else
  cards_array = ARGV.collect { |file| read_cards open(file) }
  if options.has_key? 'output'
    # merge cards
    cards = cards_array.map(&:to_a).flatten(1).reduce({}) {|h,(k,v)| (h[k] ||= []) << v; h}
    write_cards cards, open(options[:output]), options[:black], options[:white], options[:language]
  else
    cards_array.each.with_index do |cards, idx|
      write_cards cards, open(File.basename(ARGV[idx], '.*') + '.tex', 'w'), options[:black], options[:white], options[:language]
    end
  end
end
