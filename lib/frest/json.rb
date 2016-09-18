require 'frest/core'
require 'frest/json'
require 'frest/defaults'
require 'sqlite3'
require 'securerandom'
require 'json'

require_relative 'tap_h'
require_relative 'relation'

module Frest
  module Json
    include TapH
    include Frest::Relation
    include Frest::Defaults

    extend self

    tap_h def set(
        id:,
        content:,
        branch_id: DEFAULT_BRANCH_ID,
        store_id: DEFAULT_STORE_ID,
        c_:,
        **_)

      created = Time.now.strftime('%Y-%m-%d %H:%M:%S.%12N')
      sql = %{
        INSERT INTO #{store_id}(
          id,
          branch_id,
          content)
        VALUES(
          #{prepare_value(value: id)},
          #{prepare_value(value: branch_id)},
          #{prepare_value(value: content.to_json)}
        )
      }

      execute(
        sql: sql,
        **c_
      )
    end

    tap_h def delete(
        id:,
        branch_id: DEFAULT_BRANCH_ID,
        db: DEFAULT_DB,
        store_id: DEFAULT_STORE_ID,
        c_:,
        **_)

      sql = %{
        DELETE FROM #{store_id}
        WHERE
          id = '#{id}' AND
          branch_id = '#{branch_id}'
      }
      execute(
          sql: sql,
          **c_)
    end


    tap_h def get(
        id:,
        store_id: DEFAULT_STORE_ID,
        branch_id: DEFAULT_BRANCH_ID,
        db: DEFAULT_DB,
        c_:,
        **_)

      result = get_first_row(
          sql: %{
            SELECT
              content
            FROM
              #{store_id}
            WHERE
              id = '#{id}' AND
              branch_id = '#{branch_id}'},
           **c_)
      if result
        JSON.parse(result[0])
      else
        Frest::Core::NotFound
      end
    end


    tap_h def prepare_value(
        value:,
        c_:,
        **_)
        "'#{SQLite3::Database.quote(value.to_s)}'"
    end

    tap_h def execute(
      db: DEFAULT_DB,
      connection: get_connection(file: db),
      sql: '',
      log: LOG_SQL,
      c_:,
      **_
    )
      p "#{sql}\n\n" if log
      connection.execute sql

    rescue Exception => e
      p "Exception #{e} executing #{sql}"
    end

    tap_h def get_first_row(
        db: DEFAULT_DB,
        connection: get_connection(file: db),
        sql: '',
        log: LOG_SQL,
        c_:,
        **_
    )
      p "#{sql}\n\n" if log
      connection.get_first_row sql

    rescue Exception => e
      p "Exception #{e} executing #{sql}"
    end

    private

    def uuid
      SecureRandom.uuid
    end
  end
end
