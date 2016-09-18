require 'spec_helper'
require 'securerandom'
require 'frest/json'

require_relative '../../lib/frest/pubsub'

describe Frest::Pubsub do
  id1 = SecureRandom.uuid

  it 'catches updates' do
    j = Frest::Json
    p = Frest::Pubsub
    store = p.wrap(store: j)

    @foo = nil
    @content = {add: {x1: 1, x2: 2}}

    store.subscribe(
        source: id1,
        sink: ->(
            id:,
            content:
          ) {
            @foo = content
          }
        )

    store.set(id: id1, content: 1)

    #Need a way to ephemerally publish a dynamic functiion at a static id
    #Perhaps a local-reference lookup that maps a symbol to a uuid so the identifier can be randomized

    expect(store.get(id: id1)).to eq(1)
    expect(@foo).to be_nil

    store.set(id: id1, content: @content)

    expect(@foo).to eq(@content)
  end
end
