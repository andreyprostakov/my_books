class RemoveOldCoverUrlFromEditions < ActiveRecord::Migration[5.0]
  def change
    remove_column :editions, :old_cover_url
  end
end
