require 'spec_helper'
require 'frest/composers'
require 'frest/memory_store'
require 'frest/lambda'

module FunctionStore
  module_function

  def add(
    x1:,
    x2:
  )

    x1 + x2
  end

  def times(
    x1:,
    x2:
  )

    x1 * x2
  end

  def get(
    id:
  )
    method(id) rescue Frest::Core::NotFound
  end
end

describe Frest::Lambda do
  before :all do
    m = Frest::MemoryStore
    f = FunctionStore
    @lambda = Frest::Lambda
    @store = Frest::Composers.priority(endpoints: [f, m])
  end

  it 'can create and call a function' do
    @store.set(
        id: 'cc440e9f-9973-4c54-acf2-45f34f7acd45',
        content: {add: {x1: 1, x2: 2}})
    value = @lambda.get(
        id: 'cc440e9f-9973-4c54-acf2-45f34f7acd45',
        store: @store)
    expect(value).to eq(3)
  end

  it 'can just execute a json function' do
    j = {
        add: {x1: 1, x2: 2}
    }

    result = Frest::Lambda.execute(
       json: j,
       store: @store
    )

    expect(result).to eq(3)
  end
end
