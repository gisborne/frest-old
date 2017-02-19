require 'frest/core'
require 'frest/json'

module Frest
  DEFAULT_STORE = Frest::Json

  module PathStore
    def set(
      id: '',
      value:,
      store: DEFAULT_STORE
    )

      path = id_to_path(id)

      if path.length == 0
        store.set(
          id: '',
          value: value
        )
      elsif path.length == 1
        store.set(
          id: path.first,
          value: value
        )
      else
        head = path.shift

        current = store.get(head)
        current = (current == Frest::Core::NotFound) ? {} : current

        return Frest::Core::AttemptToSetScalar unless current.is_a? Hash

        current[id] = value
        store.set id: id, value: current
      end
    end

    def get(
      id: '',
      store: DEFAULT_STORE
    )

      path = id_to_path(id)

      if path.length == 0
        store.get(id: '')
      elsif path.length == 1
        store.get(id: path.first)
      else
        next_hash = get(
          path: path.first,
          store: store
        )
        return Frest::Core::AttemptToDereferenceScalar unless next_hash.is_a? Hash
          .get(
            path: path[1..-1])
      end
    end

    def path_to_array(path)
      [*(path || [])]
    end

    def id_to_path(id)
      if id.is_a? String
        path = path_to_array(id.to_s.split(/(?<!\\)\//).map{|x| x.gsub('\/', '/')})
        path.shift if path.first == ''
      else
        path = id
      end
    end

    module_function :set, :get
  end
end
