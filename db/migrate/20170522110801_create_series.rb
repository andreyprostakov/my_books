class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.string :title
      t.timestamps
    end
    add_reference :editions, :series, index: true
  end
end
