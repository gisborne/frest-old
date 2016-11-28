module Frest
  class Server
    module Database
      require 'sqlite3'
      require 'rbnacl'
      require 'fileutils'

      def self.init(
          name:,
          database_name: 'system.db',
          **c)
        path = mkdir(name: name, **c)

        db = SQLite3::Database.new File.join(path, database_name)

        create_accounts_table(db: db, **c)
      end

      def self.create_accounts_table(db:)
        rows = db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS
            accounts(
              name varchar(50),
              hash char(32)
            )
        SQL
      end

      def self.mkdir(name:, system_dir_name: 'system', **c)
        path = File.join(name, system_dir_name)
        FileUtils.mkdir_p(path) unless File.directory?(path)
        path
      end
    end
  end
end
