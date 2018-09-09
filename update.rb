#!/usr/bin/env ruby
require 'uri'

all = Dir['images/*.png'].map do |fn|
  font, size, program = File.basename(fn, '.png').split('_')
  [ font, size, program, File.basename(fn) ]
end

all.sort_by! { |x| x[3] }

out = STDOUT

out.puts "# Linux Font Madness"
out.puts "Shitty inconsistent font rendering across Linux terminals and editors"
out.puts

last_font_name = nil
all.each do |font, size, program, fn|
  font_name = "#{font}-#{size}"
  if font_name != last_font_name
    out.puts "## #{font_name}"
    last_font_name = font_name
    out.puts
  end
  url = URI.escape("https://raw.githubusercontent.com/larsch/linux-font-madness/master/images/#{fn}")
  out.puts "![#{fn}](#{url})"
  out.puts "*#{program}*"
  out.puts
end
