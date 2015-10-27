class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :code,       null: false
      t.integer :token_type, null: false
      t.boolean :active,    default: true
      t.json :context

      t.timestamps null: false
    end
  end
end
