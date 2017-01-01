class AddPublicationYearToEdition < ActiveRecord::Migration[5.0]
  def change
    add_column :editions, :publication_year, :integer, default: 1999
  end
end
