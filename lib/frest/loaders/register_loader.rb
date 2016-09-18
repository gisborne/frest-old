module Frest
  module Core
    module Loaders
      @loaders = {
          types:      {},
          type_names: {}
      }

      def register_loader loader:, file_types:, type_name:
        file_types.each do |type|
          @loaders[:types][type] ||= []
          @loaders[:types][type] << loader
        end

        @loaders[:type_names][type_name] ||= []
        @loaders[:type_names][type_name] << loader
      end

      def loaders
        @loaders
      end

      module_function :register_loader
      module_function :loaders
    end
  end
end