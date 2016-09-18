module Frest
  module Relation
    def create_relation(
        name:,
        fields: [],
        keys: [:id]
    )
      fields[:id] = :uuid
      keys << :id unless keys.include?(:id)

      sql = %{
        CREATE TABLE IF NOT EXISTS
          #{name} (
            #{fields.map { |k, v| field_create_string(name: k, type: v, keys: keys) } * ",\n"},
            PRIMARY KEY(#{keys * ', '})
          )
          WITHOUT ROWID
      }

      result = execute(sql: sql)
      result
    end

    def insert_relation(
        name:,
        fields: [],
        values: []
    )

      sql = %{
        INSERT INTO
          #{name}(
          #{fields * ','}
        )
        VALUES(#{(values.map { |row| row_to_sql(row: row) }) * '), ('})
      }

      result = execute(sql: sql)
      result
    end

    def find_relation(
        name:,
        where: {},
        fields: []
    )
      sql = %{
          SELECT
            #{fields * ",\n"}
          FROM
            #{name}
          WHERE
            #{where_to_sql(where: where)}
      }

      result = execute(sql: sql)
      result.empty? ? Frest::Core::NotFound : result.first
    end

    def update_relation(
        name:,
        where: {},
        values: {}
    )

      sql = %{
          UPDATE
            #{name}
          SET
            #{values_to_assignment(values: values)}
          WHERE
            #{where_to_sql(where: where)}
      }

      result = execute(sql: sql)
      result
    end

    def delete_relation(
        name:,
        where: {}
    )
        sql = %{
          DELETE FROM
            #{name}
          WHERE
            #{where_to_sql(where: where)}
        }

        result = execute(sql: sql, log: true)
        result
    end


    private

    def field_create_string(
        name:,
        type:,
        keys:
    )
      "#{name} #{type}#{keys.include?(name) ? ' NOT NULL' : ''}"
    end

    def row_to_sql(
        row:
    )

      row.map { |v| prepare_value(value: v) } * ', '
    end

    def where_to_sql(
        where:
    )
      where.map { |f, v| field_to_where_clause(field: f, value: v) } * " AND\n"
    end

    def field_to_where_clause(
        field:,
        value:
    )

      "#{field_name_to_lhs(fname: field)} #{prepare_value(value: value)}"
    end

    def field_name_to_lhs(
        fname:
    )

      comparator = fname.to_s.split('_').last
      name       = fname[0..-(comparator.length + 2)]

      "#{name} #{comparator_to_sql(c: comparator)}"
    end

    def comparator_to_sql(
        c:
    )

      {
          'eq'  => '=',
          'lt'  => '<',
          'gt'  => '>',
          'lte' => '<=',
          'gte' => '>=',
          'ne'  => '<>'
      }[c]
    end

    def values_to_assignment(
      values:
    )

      values.map{|k, v| "#{k} = #{prepare_value(value: v)}"} * ",\n"
    end
  end
end
