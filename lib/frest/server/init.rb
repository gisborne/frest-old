module Frest
  class Server
    require 'frest/server/database'

    def self.setup
      name = ARGV[1]

      copy_template(name: name)
      update_database
    end

    def self.copy_template(name:)
      @name = ARGV[1] || 'default'
      FileUtils.copy_entry File.expand_path('../../../templates/init', __FILE__), name
    end

    def self.update_database
      Frest::Server::Database.init(name: name)
    end
  end
end
