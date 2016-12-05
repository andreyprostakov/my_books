class AddAnnotationToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :annotation, :text
  end
end
