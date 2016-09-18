require 'frest/core'
require 'frest/rich_function'

module Frest
  module RubyLoader
    module_function def load content:, id:, **c
      @returns = nil

      eval content
      module_function id
      result = method id

      Frest::RichFunction::enrich(fn: result)
    end

    module_function def types
      {file_types: ['rb'], type_name: 'rb'}
    end
  end
end

# Frest::Core::Loaders.register_loader loader: Frest::RubyLoader, file_types: ['rb'], type_name: 'rb'
