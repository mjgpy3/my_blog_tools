require './lib/to_html'

describe '#ensure_file_is_markdown' do

  context 'when the filename does not end in .md' do

    let(:file_name) { 'foobar.txt' }

    it 'raises an error' do
      expect { ensure_file_is_markdown(file_name) }.to raise_error(RuntimeError)
    end

  end

  context 'when the filename does end in .md' do

    let(:file_name) { 'foobar.md' }

    it 'does not raise an error' do
      ensure_file_is_markdown(file_name)
    end

  end

end

describe '#md_file_name_to_html' do

  context 'when a md filename is given' do

    let(:md_file) { 'foobar.md' }

    it 'returns a filename beginning with the original filename minus extension' do
      md_file_name_to_html(md_file).should start_with('foobar')
    end

    it 'returns a filename with a html extension' do
      md_file_name_to_html(md_file).should end_with('.html')
    end

    it 'returns a filename replacing the .md with .html' do
      md_file_name_to_html(md_file).should == 'foobar.html'
    end

  end

end

describe PreProcessor do

  describe '#given_text' do

    let(:described_method) { ->(text){ subject.given_text(text) } }

    it 'sets @text' do
      described_method.call('foobar')
      subject.translated.should == 'foobar'
    end

    it 'returns the preprocessor' do
      described_method.call(anything).should equal(subject)
    end

  end

  describe '#translated' do

    let(:described_method) { ->{ subject.translated } }

    it 'gets @text' do
      subject.instance_variable_set(:@text, 'foobar')
      described_method.call.should == 'foobar'
    end

  end

  describe '#code_blocks_to_pres' do

    let(:described_method) { ->{ subject.code_blocks_to_pres } }

    context 'when text has been given' do

      before(:each) do
        subject.given_text('foobar')
      end

      it 'returns the preprocessor' do
        described_method.call.should equal(subject)
      end

    end

    context 'when @text has no code blocks' do

      let(:text) { 'I am just some text with no code blocks' }

      before(:each) do
        subject.given_text(text)
        described_method.call
      end

      it 'leaves @text unaltered' do
        subject.instance_variable_get(:@text).should == text
      end

    end

    context 'when @text has a single code block' do

      let(:text_in_blocks) { 'foobar' }
      let(:text) { "I have a codeblock here: ```#{text_in_blocks}```" }

      before(:each) do
        subject.given_text(text)
        described_method.call
      end

      it 'leaves no trace of the original code block indicators' do
        subject.instance_variable_get(:@text).should_not include('```')
      end

      it 'replaces the first block indicator with a beginning pre tag' do
        subject.instance_variable_get(:@text).should include('<pre class="prettyprint">' + text_in_blocks)
      end

      it 'replaces the second block with an end pre tag' do
        subject.instance_variable_get(:@text).should include(text_in_blocks + '</pre>')
      end

    end

    context 'when @text has multiple code blocks' do

      let(:text) { '````````````' }

      before(:each) do
        subject.given_text(text)
        described_method.call
      end

      it 'replaces indicators with alternating pre begin and end tags' do
        subject.translated.should ==
          '<pre class="prettyprint"></pre><pre class="prettyprint"></pre>'
      end

    end

  end

  describe '#links_to_hrefs' do

    let(:described_method) { ->{ subject.links_to_hrefs } }

    let(:link_text) { 'Some Link' }
    let(:link_location) { 'http://foobar.com' }
    let(:md_link) { "[#{link_text}]{#{link_location}}" }

    context 'when text has been given' do

      before(:each) do
        subject.given_text('foobar')
      end

      it 'returns the preprocessor' do
        described_method.call.should equal(subject)
      end

    end

    context 'when @text has no MD style links' do

      let(:markdown) { 'foobar, foobaz, foobiz' }
      before(:each) do
        subject.given_text(markdown)
      end

      it 'leaves the original text unchanged' do
        described_method.call
        subject.translated.should == markdown
      end

    end

    context 'when @text has one MD style link' do

      before(:each) do
        subject.given_text("here is a link: #{md_link}")
        described_method.call
      end

      it 'leaves no trace of the markdown link in the original text' do
        subject.translated.should_not include(md_link)
      end

      it 'includes the beginning of an a href tag' do
        subject.translated.should include('<a href')
      end

      it 'has the value originally in curly braces as the href link' do
        subject.translated.should include('href="' + link_location + '">')
      end

      it 'has the value originally in square braces as the tag value' do
        subject.translated.should include(">#{link_text}</a>")
      end

    end

    context 'when @text has two MD style links' do

      before(:each) do
        subject.given_text('foo' + md_link + ' bar ' + md_link)
        described_method.call
      end

      it 'leaves no trace of the markdown link in the original text' do
        subject.translated.should_not include(md_link)
      end

    end

  end

end
