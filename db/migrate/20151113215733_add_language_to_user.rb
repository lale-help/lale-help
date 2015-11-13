class AddLanguageToUser < ActiveRecord::Migration
  def change
    add_column :users, :language, :integer, default: 0
  end
end
