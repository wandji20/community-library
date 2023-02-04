class RemoveDetailsFromReadings < ActiveRecord::Migration[7.0]
  def change
    remove_index :readings, :book_id
    remove_column :readings, :book_id, :integer
    remove_column :readings, :use_period, :integer
  end
end
