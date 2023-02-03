class CreateReadings < ActiveRecord::Migration[7.0]
  def change
    create_table :readings do |t|
      t.integer :user_id
      t.integer :library_id
      t.integer :book_id
      t.integer :status, default: 0
      t.integer :use_period
      t.datetime :signed_at
      t.datetime :returned_at
      t.integer :return_library_id

      t.timestamps
    end
    add_index :readings, :user_id
    add_index :readings, :library_id
    add_index :readings, :book_id
    add_index :readings, :return_library_id
  end
end
