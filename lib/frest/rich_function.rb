module Frest
  module RichFunction
    #@enriched is to track the params used by the resulting curried functions
    @enriched = {}

    def enrich fn:
      result = ->(**args){
        begin
          #workaround for https://bugs.ruby-lang.org/issues/10856
          if args.empty?
            fn.call
          else
            fn.call(**args)
          end
        rescue ArgumentError
          result2 = ->(**args2){fn.call(**(args.merge(args2)))}
          @enriched[result2] = fn.parameters.reject{|_, v| args.has_key? v}
          result2
        end
      }

      @enriched[result] = fn.parameters

      result
    end

    def params fn:
      @enriched[fn] || fn.params
    end
    module_function :enrich
    module_function :params
  end
end
