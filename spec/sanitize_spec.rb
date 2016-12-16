require 'spec_helper'

describe Bergamasco::Sanitize do
  subject { Bergamasco::Sanitize }

  it 'should remove a tags' do
    text = "In 1998 <strong>Tim Berners-Lee</strong> coined the term <a href=\"https://www.w3.org/Provider/Style/URI\">cool URIs</a>"
    content = subject.sanitize(text)
    expect(content).to eq("In 1998 <strong>Tim Berners-Lee</strong> coined the term cool URIs")
  end

  it 'should only keep specific tags' do
    text = "In 1998 <strong>Tim Berners-Lee</strong> coined the term <a href=\"https://www.w3.org/Provider/Style/URI\">cool URIs</a>"
    content = subject.sanitize(text, tags: ["a"])
    expect(content).to eq("In 1998 Tim Berners-Lee coined the term <a href=\"https://www.w3.org/Provider/Style/URI\">cool URIs</a>")
  end
end
