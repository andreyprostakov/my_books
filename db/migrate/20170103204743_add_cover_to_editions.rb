class AddCoverToEditions < ActiveRecord::Migration[5.0]
  def change
    add_column :editions, :cover, :string
    rename_column :editions, :cover_url, :old_cover_url
  end
end
