require 'spec_helper'
require 'frest/json_loader'

describe Frest::JsonLoader do
  it 'can load JSON' do
    f      = File.read('spec/test_data/test.json')
    result = Frest::JsonLoader::load(content: f, id: 'test')

    expect(result).to match('a' => 1, 'b' => 2)
  end
end
