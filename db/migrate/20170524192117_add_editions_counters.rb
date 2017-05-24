class AddEditionsCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :editions_count, :integer, default: 0, null: false
    add_column :publishers, :editions_count, :integer, default: 0, null: false
    add_column :series, :editions_count, :integer, default: 0, null: false
  end
end
