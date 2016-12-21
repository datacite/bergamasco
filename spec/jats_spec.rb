require 'spec_helper'

describe Bergamasco::Jats do
  subject { Bergamasco::Jats }

  it 'should convert to jats' do
    filepath = fixture_path + 'cool-dois.html.md'
    file = IO.read(filepath)
    xml = subject.render_jats(file, skip_yaml_header: true, csl: 'spec/fixtures/apa.csl', bibliography: 'spec/fixtures/references.yaml')
    doc = Nokogiri::XML(xml)
    article_id = doc.at_xpath("//article-id")
    expect(article_id.text).to eq("10.23725/0000-03VC")
    expect(article_id.values.first).to eq("doi")
  end

  it 'should write jats xml' do
    filepath = fixture_path + 'cool-dois.html.md'
    xml_path = subject.write_jats(filepath, skip_yaml_header: true, csl: 'spec/fixtures/apa.csl', bibliography: 'spec/fixtures/references.yaml')
    doc = File.open(xml_path) { |f| Nokogiri::XML(f) }
    article_id = doc.at_xpath("//article-id")
    expect(article_id.text).to eq("10.23725/0000-03VC")
    expect(article_id.values.first).to eq("doi")
  end
end
