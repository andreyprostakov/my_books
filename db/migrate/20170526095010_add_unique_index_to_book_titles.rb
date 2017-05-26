class AddUniqueIndexToBookTitles < ActiveRecord::Migration[5.0]
  def change
    add_index :books, [:edition_id, :title], unique: true
  end
end
