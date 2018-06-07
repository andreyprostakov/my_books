class MakeEditionsIsbnNullable < ActiveRecord::Migration[5.0]
  class Edition < ActiveRecord::Base
    EMPTY_ISBN = 'unknown'.freeze
  end

  def up
    change_column :editions, :isbn, :string, null: true
    Edition.reset_column_information
    Edition.where(isbn: Edition::EMPTY_ISBN).update_all(isbn: nil)
  end

  def down
    Edition.where(isbn: nil).update_all(isbn: Edition::EMPTY_ISBN)
    change_column :editions, :isbn, :string, null: false
  end
end
