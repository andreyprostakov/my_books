class AddRemovedToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :removed, :boolean, default: false, null: false
  end
end
