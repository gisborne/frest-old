require 'frest/core'

module Frest
  module MemoryStore

    module_function

    @@store = Hash.new(Frest::Core::NotFound)

    def set(
      id:,
      content:,
      **c
    )

      hash = final_hash(**c)

      hash[id] = content
    end

    def delete(
      id:,
      **c
    )

      hash = final_hash(**c)

      hash.delete(id)
    end

    def get(
      id:,
      **c
    )

      hash = final_hash(**c)

      hash[id]
    end



    def uuid
      SecureRandom.uuid
    end

    def final_hash(
      store_id: 'default',
      branch_id: 'default',
      **c
    )

      @@store[branch_id] = Hash.new{Frest::Core::NotFound} if @@store[branch_id] == Frest::Core::NotFound
      @@store[branch_id][store_id] = Hash.new{Frest::Core::NotFound} if @@store[branch_id][store_id] == Frest::Core::NotFound
      @@store[branch_id][store_id]
    end
  end
end
