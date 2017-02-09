class AddReadToEditions < ActiveRecord::Migration[5.0]
  def change
    add_column :editions, :read, :boolean, default: false
  end
end
