require 'spec_helper'

describe Frest::MemoryStore do
  n = Frest::MemoryStore

  describe "Basic CRUD" do
    it "can store a value and retrieve it" do
      n.set id: '69c9ed0a-b83a-4816-93e7-80a34265a949', content: {'foo' => 1, 'bar' => 'bar'}
      expect(n.get id: '69c9ed0a-b83a-4816-93e7-80a34265a949').to match({'foo' => 1, 'bar' => 'bar'})
    end

    it "can delete an entire hash and it's gone" do
      n.set id: '3ff7bacf-1511-4709-b84f-2427e91b01e8', content: {a: 1}
      n.delete id: '3ff7bacf-1511-4709-b84f-2427e91b01e8'
      expect(n.get(id: '3ff7bacf-1511-4709-b84f-2427e91b01e8')).to eq(Frest::Core::NotFound)
    end

    it "can insert and retrieve a nested hash" do
      n.set id: 'aaabee95-5aaf-4c3a-bfd6-49c8d1bae0df', content: {'a' => 1, 'b' => {'c' => 2}}
      expect(n.get(id: 'aaabee95-5aaf-4c3a-bfd6-49c8d1bae0df')).to match({'a' => 1, 'b' => {'c' => 2}})
    end

    it 'receives Frest::Core::NotFound when a value doesn' 't exist' do
      expect(n.get id: 'de7c2cd4-daca-4e32-ad33-0a7bcadb9840').to eq(Frest::Core::NotFound)
    end
  end
end