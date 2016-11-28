module Frest
  class Server
    require 'frest/server/database'

    def self.init
      name = ARGV[1]

      copy_template(name: name)
      Frest::Server::Database.init(name: name)
    end

    def self.copy_template(name:)
      @name = ARGV[1]
      FileUtils.copy_entry File.expand_path('../../../templates/init', __FILE__), name
    end
  end
end
