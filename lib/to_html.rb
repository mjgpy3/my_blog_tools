#!/usr/bin/env ruby

require 'redcarpet'

def ensure_file_is_markdown(file_name)
  fail RuntimeError unless file_name.end_with?('.md')
end

def md_file_name_to_html(file_name)
  file_name.sub(/\.md$/, '.html')
end

def markdown_to_html(markdown_text)
  renderer = Redcarpet::Render::HTML.new(render_options = {prettify: true})
  markdown  = Redcarpet::Markdown.new(renderer, extensions = {})
  markdown.render(markdown_text)
end

class PreProcessor

  MD_LINK_RE = /\[([^\]]+)\]\{([^\}]+)\}/

  def given_text(md_text)
    @text = md_text
    self
  end

  def translated
    @text
  end

  def links_to_hrefs
    while @text.match(MD_LINK_RE)
      @text.sub!(MD_LINK_RE, "<a href=\"#{$2}\">#{$1}</a>")
    end
    self
  end

  def code_blocks_to_pres
    while @text.include?('```')
      @text = @text.sub('```', '<pre class="prettyprint">')
                   .sub('```', '</pre>')
    end
    self
  end

end

if __FILE__ == $0
  ensure_file_is_markdown(ARGV[0])
  to_convert = ARGV[0]
  output_name = md_file_name_to_html(to_convert)
  puts "Converting #{to_convert} to #{output_name}"

  file_text = File.read(to_convert)

  processed_text =
    PreProcessor.new
                .given_text(file_text)
                .links_to_hrefs
                .code_blocks_to_pres
                .translated

  converted = markdown_to_html(processed_text)

  File.open(output_name, 'w') do |f|
    f.puts converted
  end
end
