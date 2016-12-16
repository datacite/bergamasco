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

  it 'should update yaml frontmatter' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    new_metadata = { "doi" => "10.23725/0000-03VC"}
    metadata, content = subject.split_yaml_frontmatter(file)
    metadata = subject.update_yaml_frontmatter(metadata, new_metadata)
    expect(metadata["doi"]).to eq("10.23725/0000-03VC")
  end

  it 'should update yaml frontmatter remove attribute' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    new_metadata = { "title" => nil }
    metadata, content = subject.split_yaml_frontmatter(file)
    metadata = subject.update_yaml_frontmatter(metadata, new_metadata)
    expect(metadata["title"]).to be nil
  end

  it 'should join yaml frontmatter' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    metadata, content = subject.split_yaml_frontmatter(file)
    updated_file = subject.join_yaml_frontmatter(metadata, content)
    expect(updated_file).to eq(file)
  end

  it 'should read yaml' do
    filepath = fixture_path + 'cool-dois.yml'
    metadata = subject.read_yaml(filepath)
    expect(metadata["title"]).to eq("Cool DOI's")
  end

  it 'should write yaml' do
    filepath = fixture_path + 'cool-dois.yml'
    text = IO.read(filepath)
    metadata = subject.read_yaml(filepath)
    length = subject.write_yaml(filepath, metadata)
    expect(length).to eq(text.length)
  end

  it 'should update file' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    new_metadata = { "doi" => "10.23725/0000-03VC"}
    updated_file = subject.update_file(file, new_metadata)
    expect(updated_file).to include("\ndoi: 10.23725/0000-03VC\n")
  end

  it 'should convert markdown' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    html = subject.render_html(file, skip_yaml_header: true)
    expect(html).to start_with("<p>In 1998 Tim Berners-Lee coined")
  end
end
