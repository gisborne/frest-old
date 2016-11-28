require 'ostruct'
require 'erb'

module Frest
  class ERBFile < OpenStruct
    def render(template)
      x = ERB.new(File.read(File.expand_path(template))).result(binding)
    end
  end
end
