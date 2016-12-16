require 'spec_helper'

describe Bergamasco::Yaml do
  subject { Bergamasco::Yaml }

  it 'should split yaml frontmatter' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    metadata, content = subject.split_yaml_frontmatter(file)
    expect(metadata).to have_key("title")
    expect(content).to start_with("In 1998 Tim Berners-Lee coined")
  end
end
