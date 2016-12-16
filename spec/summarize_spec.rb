require 'spec_helper'

describe Bergamasco::Summarize do
  subject { Bergamasco::Summarize }

  it 'should truncate after 250 characters' do
    filepath = fixture_path + 'cool-dois-without-yml.md'
    file = IO.read(filepath)
    content = subject.summary(file)
    expect(content.length).to eq(250)
    expect(content).to start_with("In 1998 Tim Berners-Lee coined")
  end

  it 'should truncate after 75 characters' do
    filepath = fixture_path + 'cool-dois-without-yml.md'
    file = IO.read(filepath)
    content = subject.summary(file, length: 75)
    expect(content.length).to eq(83)
    expect(content).to start_with("In 1998 Tim Berners-Lee coined")
  end

  it 'should truncate at separator' do
    filepath = fixture_path + 'cool-dois-without-yml.md'
    file = IO.read(filepath)
    separator = "READMORE"
    content = subject.summary(file, separator: separator)
    expect(content).to start_with("In 1998 Tim Berners-Lee coined")
    expect(content).to end_with("the referenced resource.")
  end
end
