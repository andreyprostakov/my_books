class AddTimestamps < ActiveRecord::Migration[5.0]
  def change
    %i(authors editions).each do |table|
      add_column(table, :created_at, :datetime)
      add_column(table, :updated_at, :datetime)
    end
  end
end
