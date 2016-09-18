require 'json'

module Frest
  module JsonLoader
    module_function def load content:, id:, **c
      JSON.parse content
    end

    module_function def types
      {file_types: ['json'], type_name: 'json'}
    end
  end
end
