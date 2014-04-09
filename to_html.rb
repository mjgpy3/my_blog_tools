#!/usr/bin/env ruby

require 'redcarpet'

if __FILE__ == $0
  renderer = Redcarpet::Render::HTML.new(render_options = {prettify: true})
  markdown  = Redcarpet::Markdown.new(renderer, extensions = {})

  fail "Must pass markdown file as param" unless ARGV[0] =~ /\.md/
  to_convert = ARGV[0]
  output_name = to_convert.sub(/\.md/, '.html')
  puts "Converting #{to_convert} to #{output_name}"

  file_text = File.read(to_convert)
  preproc_text = ''
  use_pre = true

  file_text.split("\n").each do |line|
    while line.match(/\[(.+)\]\{(.+)\}/)
      matches = line.match(/\[(.+)\]\{(.+)\}/).to_a
      line = line.sub(matches[0], "<a href=\"#{matches[2]}\">#{matches[1]}</a>")
    end
    if line.include? '```'
      preproc_text << line.sub(/```/, (use_pre ? '<pre class="prettyprint">' : '</pre>')) + "\n"
      use_pre = !use_pre
    else
      preproc_text << line + "\n"
    end
  end

  converted = markdown.render(preproc_text)

  File.open(output_name, 'w') do |f|
    f.puts converted
  end
end
