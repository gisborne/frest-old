require 'spec_helper'

describe Frest::RubyLoader do
  it 'handles basic function recall and execution' do
    f     = File.read('spec/test_fns/times.rb')
    times = Frest::RubyLoader::load(content: f, id: 'times')
    expect(times.call(x1: 2, x2: 5)).to eq(10)

    expect(times.call())
    g   = File.read('spec/test_fns/add.rb')
    add = Frest::RubyLoader::load(content: g, id: 'add')
    expect(add.call(x1: 2, x2: 5)).to eq(7)
  end
end
