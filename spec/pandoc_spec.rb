require 'spec_helper'

describe Bergamasco::Pandoc do
  subject { Bergamasco::Pandoc }

  it 'should convert markdown' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    html = subject.convert(file, skip_yaml_header: true, csl: 'spec/fixtures/apa.csl', bibliography: 'spec/fixtures/references.yaml')
    expect(html).to start_with("<p>In 1998 Tim Berners-Lee coined the term cool URIs <span class=\"citation\">(1998)</span>, that is URIs that don’t change.")
  end

  it 'should convert to jats' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    xml = subject.convert_to_jats(file, skip_yaml_header: true, csl: 'spec/fixtures/apa.csl', bibliography: 'spec/fixtures/references.yaml')
    doc = Nokogiri::XML(xml)
    article_id = doc.at_xpath("//article-id")
    expect(article_id.text).to eq("10.5072/0000-03VC")
    expect(article_id.values.first).to eq("doi")
  end

  it 'should write bibliography to yaml' do
    bib_path = fixture_path + 'references.bib'
    yaml_path = fixture_path + 'references.yaml'
    yaml = subject.write_bibliograpy_to_yaml(bib_path, yaml_path)
    expect(yaml["references"].length).to eq(61)
  end
end
