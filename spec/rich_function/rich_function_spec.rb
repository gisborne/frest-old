require 'spec_helper'

describe Frest::RichFunction do
  it 'can call a rich function' do
    f = Frest::RichFunction.enrich(fn: ->(a:){a})
    expect(f.call(a: 1)).to eq(1)
  end

  it 'can curry a rich function' do
    f = Frest::RichFunction.enrich(fn: ->(a:, b:){[a, b]})
    g = f.call(a: 'A')
    expect(g.call(b: 'B')).to eq(['A', 'B'])
  end

  it 'returns the params for an enriched function' do
    f = Frest::RichFunction.enrich(fn: ->(a:, b:){[a, b]})
    expect(Frest::RichFunction.params(fn: f)).to eq([[:keyreq, :a], [:keyreq, :b]] )
    g = f.call(a: 1)
    expect(Frest::RichFunction.params(fn: g)).to eq([[:keyreq, :b]])
  end

  #Test https://bugs.ruby-lang.org/issues/10856
  it 'can call a rich function with empty args' do
    f = Frest::RichFunction.enrich(fn: ->(){:ok})
    args = {}
    expect(f.call(**args)).to eq(:ok)
  end
end
