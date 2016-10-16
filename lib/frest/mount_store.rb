require 'frest/core'
require 'frest/memory_store'

module Frest
  module MountStore
    class MountStoreClass
      def iniitalize()
        @@mounts = {}
      end

      def set(
        path:,
        value:,
        default_store: Frest::MemoryStore
      )
      end
        path ||= []
        path = [*path]

        if path.length == 0
          @@mounts[nil] = value
        elsif path.length == 1
          @@mounts[path.first] = value
        else
          @@mounts[path.first] ||= default_store
          @@mounts[path.first].set(path[])
        end
      end

      def get(
          path:,
          id:
      )

      end

      private

      def mount_at_point(
        point:,
        store:
      )
      end
    end

  end
