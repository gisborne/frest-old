require_relative('tap_h')
require 'sqlite3'

module Frest
  module Defaults
    require 'pp'

    extend TapH

    DEFAULT_DB        = 'default.sqlite'
    DEFAULT_STORE_ID  = 'root'
    DEFAULT_BRANCH_ID = 'root'
    LOG_SQL           = false

    @@connections = {}

    tap_h def execute(
      sql: '',
      log: LOG_SQL,
      db: DEFAULT_DB,
      connection: get_connection(file: db),
      c_:,
      **_
    )
      pp "#{sql}\n\n" if log
      connection.execute(sql)
    rescue Exception => e
      p "Exception #{e} executing #{sql}"
    end

    tap_h def get_connection(
      file: DEFAULT_DB,
      c_:,
      **_
    )
      f = File.absolute_path(file) #canonicalize connection by full path
      return @@connections[f] if @@connections[f]
      @@connections[f] = SQLite3::Database.new(f)
      result = @@connections[f]
      result.create_function('uuid', 0) do |func, value|
        func.result = SecureRandom.uuid
      end

      result
    end
  end
end