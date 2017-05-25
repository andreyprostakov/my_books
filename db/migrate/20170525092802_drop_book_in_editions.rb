class DropBookInEditions < ActiveRecord::Migration[5.0]
  def change
    drop_table :book_in_editions
  end
end
