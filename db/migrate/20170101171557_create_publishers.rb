class CreatePublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :publishers do |t|
      t.string :name
      t.timestamps
    end
    add_reference :editions, :publisher, index: true
  end
end
