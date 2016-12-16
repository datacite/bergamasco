require 'spec_helper'

describe Bergamasco::Markdown do
  subject { Bergamasco::Markdown }

  it 'should split yaml frontmatter' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    metadata, content = subject.split_yaml_frontmatter(file)
    expect(metadata).to have_key("title")
    expect(content).to start_with("In 1998 Tim Berners-Lee coined")
  end

  it 'should convert markdown' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    html = subject.render_html(file, skip_yaml_header: true)
    expect(html).to start_with("<p>In 1998 Tim Berners-Lee coined")
  end
end
