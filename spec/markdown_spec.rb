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

  it 'should read yaml from markdown file' do
    filepath = fixture_path + 'cool-dois.html.md'
    metadata = subject.read_yaml(filepath)
    expect(metadata["title"]).to eq("Cool DOI's")
  end

  it 'should read yaml for doi metadata' do
    filepath = fixture_path + 'cool-dois.html.md'
    separator = "READMORE"
    metadata = subject.read_yaml_for_doi_metadata(filepath, separator: separator, csl: 'spec/apa.csl', bibliography: 'spec/references.bib')
    expect(metadata["related_identifiers"]).to eq([{:id=>"https://www.w3.org/Provider/Style/URI",
        :related_identifier_type=>"URL",
        :relation_type=>"references"},
      { :id=>"10.1371/JOURNAL.PONE.0115253",
        :related_identifier_type=>"DOI",
        :relation_type=>"references" }])
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
    html = subject.render_html(file, skip_yaml_header: true, csl: 'spec/apa.csl', bibliography: 'spec/references.bib')
    expect(html).to start_with("<p>In 1998 Tim Berners-Lee coined the term cool URIs <span class=\"citation\">(1998)</span>, that is URIs that don’t change.")
  end

  it 'should extract references' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    html = subject.render_html(file, skip_yaml_header: true, csl: 'spec/apa.csl', bibliography: 'spec/references.bib')
    refs = subject.extract_references(html, skip_yaml_header: true, csl: 'spec/apa.csl', bibliography: 'spec/references.bib')
    expect(refs).to eq([{:id=>"https://www.w3.org/Provider/Style/URI",
        :related_identifier_type=>"URL",
        :relation_type=>"references"},
      { :id=>"10.1371/JOURNAL.PONE.0115253",
        :related_identifier_type=>"DOI",
        :relation_type=>"references" }])
  end
end
