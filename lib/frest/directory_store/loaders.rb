require 'frest/ruby_loader'
require 'frest/json_loader'

module Frest
  module DirectoryStore
    def loaders
      [Frest::RubyLoader, Frest::JsonLoader]
    end

    module_function :loaders
  end
end