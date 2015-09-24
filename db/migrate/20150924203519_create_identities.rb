class CreateIdentities < ActiveRecord::Migration
  def change
    create_model :volunteer_identities do |t|
      t.long_integer :volunteer_id
      t.string :email
      t.string :password_digest
    end
  end

  def create_model name
    create_table name do |table|
      table.extend LongInteger
      table.timestamps null: false
      yield table
    end
    change_column name, :id, :integer, limit: 8
  end

  module LongInteger
    def long_integer name, opts={}
      opts = {limit: 8, null: false}.merge(opts)
      integer name, opts
    end
  end

end
