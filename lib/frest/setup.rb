require_relative 'tap_h'
require_relative 'defaults'

module Frest
  module Setup
    include TapH
    include Defaults

    extend self

    tap_h def setup(
      id: DEFAULT_STORE_ID,
      c_:,
      **_)

      #Branches tree
      execute(
        sql: %{
          CREATE TABLE IF NOT EXISTS #{id}_branches(
            id UUID NOT NULL,
            parent UUID,
            created date DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY(id, parent)
          )
            WITHOUT ROWID
        }
      )

      #Basic JSON values in branches
      execute(
        sql: %{
          CREATE TABLE IF NOT EXISTS
            #{id}_src(
              id UUID NOT NULL,
              branch_id UUID NOT NULL REFERENCES #{id}_branches,
              content TEXT,
              created DATE DEFAULT CURRENT_TIMESTAMP,

              PRIMARY KEY(id, branch_id, created)
            )
              WITHOUT ROWID
        }
      )

      #Tombstones
      execute(
        sql: %{
          CREATE TABLE IF NOT EXISTS
            #{id}_deleted(
              id UUID NOT NULL,
              branch_id UUID NOT NULL,
              deleted DATE DEFAULT CURRENT_TIMESTAMP,

              PRIMARY KEY(id, branch_id)
          )
              WITHOUT ROWID
        }
      )



      #View without tombstones
      execute(
        sql: "
          CREATE VIEW IF NOT EXISTS
            #{id} AS
          SELECT
            *
          FROM
            #{id}_src dss
          WHERE
            NOT
              EXISTS (
                SELECT 1
                FROM
                  #{id}_deleted dsd
                WHERE
                  dsd.id == dss.id AND
                  dsd.branch_id = dss.branch_id) AND
                  dss.created = (SELECT MAX(created) FROM #{id}_src WHERE id = dss.id AND branch_id = dss.branch_id)",
        **c_
      )

      #Push INSERT on view into src table
      execute(
        sql: %{
          CREATE TRIGGER IF NOT EXISTS
            #{id}_uuid_trigger1
          INSTEAD OF
            INSERT
          ON
            #{id}
          WHEN
          NOT
            EXISTS(
              SELECT 1
              FROM
                #{id}_deleted del
              WHERE
                del.id = NEW.id AND
                del.branch_id = NEW.branch_id)
          BEGIN
            INSERT INTO
              #{id}_src(
                id,
                branch_id,
                content)
              SELECT
                COALESCE(NEW.id, UUID()),
                NEW.branch_id,
                NEW.content;
          END
        },
        **c_
      )

      #Counterpart to uuid_trigger1: raise error if we try to insert when a value has been deleted
      execute(
        sql: %{
          CREATE TRIGGER IF NOT EXISTS
            #{id}_uuid_trigger2
          INSTEAD OF
            INSERT
          ON
            #{id}
          WHEN
            EXISTS(
              SELECT 1
              FROM
                #{id}_deleted del
              WHERE
                del.id = NEW.id AND
                del.branch_id = NEW.branch_id)
          BEGIN
            SELECT RAISE(FAIL, 'Deleted');
          END
        },
        **c_
      )

      execute(
        sql: %{
          CREATE TRIGGER IF NOT EXISTS
            #{id}_delete_trigger1
          INSTEAD OF
            DELETE
          ON
            #{id}
          BEGIN
            INSERT OR IGNORE INTO
              #{id}_deleted(
                id,
                branch_id
              )
              SELECT
                OLD.id,
                OLD.branch_id;
          END
        },
        **c_
      )
    end
  end
end

