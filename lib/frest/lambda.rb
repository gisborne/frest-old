module Frest
  module Lambda
    module_function

    def get(
      id:,
      store:
    )
      x = store.get(id: id)
      return x if x == Frest::Core::NotFound
      execute(
          json: x,
          store: store
      )
    end

    def execute(
      json:,
      store:
    )
      k = json.keys.first
      f = store.get(id: k)
      f.call(json[k])
    end
  end
end
