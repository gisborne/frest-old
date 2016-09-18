require 'spec_helper'
require 'frest/core'
require 'frest/directory_store'

describe Frest::DirectoryStore do
  it 'can retreive from a directory' do
    expect(Frest::DirectoryStore.get(path: 'spec/test_files', id: 'test1')).to be_a(Hash)
    expect(Frest::DirectoryStore.get(path: 'spec/test_files', id: 'test2')).to be_a(Proc)
  end

  it 'can use an object to curry the path' do
    f = Frest::DirectoryStore.new(path: 'spec/test_files')
    expect(f.get(id: 'test1')).to be_a(Hash)
    expect(f.get(id: 'test2')).to be_a(Proc)
  end

  it 'can execute functions from a directory' do
    expect(Frest::ExecDirectoryStore.get(path: 'spec/test_files', id: 'test1')).to be_a(Hash)
    expect(Frest::ExecDirectoryStore.get(path: 'spec/test_files', id: 'test2')).to eq('test2 result')
  end

  it 'can use an object to curry the path' do
    f = Frest::ExecDirectoryStore.new(path: 'spec/test_files')
    expect(f.get(id: 'test1')).to be_a(Hash)
    expect(f.get(id: 'test2')).to be_a(Proc)
  end

  it 'gets Frest::Core::NotFound if not there' do
    expect(Frest::DirectoryStore.get(path: 'spec/test_files', id: 'not_there')).to eq(Frest::Core::NotFound)
  end
end
