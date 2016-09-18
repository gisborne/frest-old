require 'frest/directory_store/loaders'
require 'frest/core'

require_relative 'directory_store'

module Frest
  module ExecDirectoryStore
    class ExecDirectoryStoreClass
      def initialize(path:)
        @path = path
      end

      def get(**c)
        DirectoryStore.get(**c.merge(path: @path))
      end
    end

    def get(
        args: {},
        **c
    )

      it = Frest::DirectoryStore.get(**c)

      return it.call(**args) if it.is_a? Proc
      it
    end

    def new(path:)
      ExecDirectoryStoreClass.new(path: path)
    end

    module_function :get, :new
  end
end
