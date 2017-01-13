class StoreUserProfileImageFilename < ActiveRecord::Migration
  def change
    add_column :users, :profile_image_filename, :string
  end
end
