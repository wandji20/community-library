class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :author_id
      t.integer :library_id
      t.string :title
      t.integer :published_year

      t.timestamps
    end
    add_index :books, :author_id
    add_index :books, :library_id
  end
end
