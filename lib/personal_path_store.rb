require 'frest/core'
require 'frest/json'
require 'frest/path_store'

module Frest
  DEFAULT_STORE = Frest::PathStore

  module PersonalPathStore
    %i{set get}.each do |m|
      define_method(m) do |id:, token:, path_sub_store: DEFAULT_STORE, **c|
        path = path_sub_store::id_to_path(id).unshift(token)
        path_sub_store.send(m, id: path, **c)
      end
    end
  end
end
