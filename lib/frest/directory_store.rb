require 'frest/core'

module Frest
  module DirectoryStore
    class DirectoryStoreClass
      def initialize(path:)
        @path = path
      end

      def get(**c)
        DirectoryStore.get(**c.merge(path: @path))
      end
    end

    def get(
        path:,
        id:,
        loaders: Frest::DirectoryStore::loaders,
        types: (loaders.flat_map { |l| l.types[:file_types] })
    )

      Dir.chdir(path) do
        result = Dir.glob("#{id}.{#{types * ','}}")&.first

        if result
          parts  = result.split('.')
          f      = File.read(result)
          loader = loaders.select { |l| l.types[:file_types].include?(parts.last) }&.first
          loader&.load(content: f, id: parts[0..-2] * '')
        else
          Frest::Core::NotFound
        end
      end
    end

    def new(path:)
      DirectoryStoreClass.new(path: path)
    end

    module_function :get, :new
  end
end
