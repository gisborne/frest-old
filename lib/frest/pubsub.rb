require 'frest/directory_store'
require 'frest/ruby_loader'
require 'frest/exec_directory_store'
require 'frest/relation'

module Frest
  module Pubsub
    class PubsubClass
      def initialize(
        store:,
        directory_store: Frest::ExecDirectoryStore.new(path: __FILE__ + '/features'),
        name: 'pubsub'
      )
        @store = store
        @name = name
        store.create_relation(
          name: @name,
          fields: {
            source: :uuid,
            call:   :uuid
          },
          keys: [:source, :call]
        )
      end

      def set(
        id:,
        content:
      )
        @store.set(
          id: id,
          content: content
        )
        listeners = @store.find_relation(
          name: @name,
          where: {
            id_eq: id
          },
          fields: [:source, :call]
        )

        Frest::Lambda.execute(
           json: call,
           store: @store
        )
      end

      def subscribe(
        source:,
        sink:
      )
        @store.insert_relation(
          name: @name,
          fields: [:source, :call],
          values: [[source, sink]]
        )
      end

      def method_missing(method, *args, **kwargs)
        @store.send(method, *args, **kwargs)
      end
    end





    def self.wrap(
      store:
    )
      PubsubClass.new(store: store)
    end
  end
end
