require 'spec_helper'
require 'frest/core'
require 'securerandom'

describe Frest::Json do
  n = Frest::Json

  describe "CRUD on relations" do
    id1 = SecureRandom.uuid
    id2 = SecureRandom.uuid

    it "can create a relation" do
      n.create_relation(
        name:    't1',
        fields:  {
           id:          :uuid,
           email:       :text,
           height_m:    :real,
           stuff:       :blob,
           dob:         :date,
           time_birth:  :time,
           cars:        :integer
        }
      )
    end

    it 'can insert data into the relation' do
      n.insert_relation(
           name: 't1',
           fields: [
               :id,
               :email,
               :height_m,
               :stuff,
               :dob,
               :time_birth,
               :cars],
           values: [
                [id1, '1@a.com', 1.5, '52b2a550-e72c-4b66-8fb0-1e30da89b4de', '2005-01-01', '17:23', 0],
                [id2, '2@a.com', 1.4, 'a0ad5b0d-8ccd-4be6-8594-4a13db1946d2', '2003-06-01', '16:40', 2]
           ]
      )
    end

    it 'can find one value' do
      expect(
        n.find_relation(
          name:    't1',
          where: {
              id_eq: id1
          },
          fields: [:email, :height_m]
        )
      ).to eq(['1@a.com', 1.5])

      expect(
        n.find_relation(
            name:    't1',
            where: {
                id_eq: id2
            },
          fields: [:dob, :time_birth]
        )
      ).to eq(['2003-06-01', '16:40'])
    end

    it 'can update a value' do
      n.update_relation(
        name:    't1',
        where: {
          id_eq: id1
        },
        values: {
          height_m: 1.6,
          email: '1.5@a.com'
        }
      )

      expect(
          n.find_relation(
              name:    't1',
              where: {
                id_eq: id1
              },
              fields: [:height_m, :email, :dob]
          )
      ).to eq([1.6, '1.5@a.com', '2005-01-01'])
    end

    it 'can delete a value' do
      n.delete_relation(
          name:    't1',
          where: {
            id_eq: id1
          }
      )

      expect(
          n.find_relation(
              name:    't1',
              where: {
                id_eq: id1
              },
              fields: [:height_m, :email, :dob]
          )
      ).to eq(Frest::Core::NotFound)
    end
  end
end
