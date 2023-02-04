class AddDetailsToReadings < ActiveRecord::Migration[7.0]
  def change
    add_column :readings, :book_copy_id, :integer
    add_index :readings, :book_copy_id
    add_column :readings, :to_return_at, :datetime
  end
end
