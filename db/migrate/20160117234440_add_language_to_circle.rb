class AddLanguageToCircle < ActiveRecord::Migration
  def change
    add_column :circles, :language, :integer, default: 0, null: false
  end
end
